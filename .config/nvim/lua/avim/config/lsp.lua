_G.lsp_servers = {
  'bashls',
  'clangd',
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'tsserver',
  'verible',
}

-- add mason bin dir in the PATH to find LSP bin even in Mason is not loaded yet
local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin_path .. ":" .. vim.env.PATH

-- lspconfig
local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

local function on_attach(client, _)
  lsp_status.on_attach(client)
  vim.bo.tagfunc=nil -- don't overwrite ctags mappings/functions with LSP
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function get_lsp_settings(lsp_server)
  if lsp_server == "lua_ls" then
    local nvim_runtime_dirs = vim.api.nvim_get_runtime_file("", true)
    -- remove .configs path to avoid duplicate with dotfiles/.config
    local i = 1
    while (i <= #nvim_runtime_dirs) do
      if string.find(nvim_runtime_dirs[i], '/.config/') then
        table.remove(nvim_runtime_dirs, i)
      else
        i = i + 1
      end
    end
    return {
      Lua = {
        runtime = { version = "LuaJIT", },
        diagnostics = { globals = { "vim" }, },
        workspace = { library = nvim_runtime_dirs, },
        telemetry = { enable = false, },
      },
    }
  end
  return {}
end

for _, lsp in ipairs(_G.lsp_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = get_lsp_settings(lsp),
    filetypes = lsp == 'verible' and { 'verilog_systemverilog' } or nil,
  }
end

-- diagnostics
local signs = { Error = ">>", Warn = ">>", Hint = ">>", Info = ">>" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local lsp_virtual_text = true
function _G.ToggleLspVirtualText()
  lsp_virtual_text = not lsp_virtual_text
  vim.diagnostic.config({ virtual_text = lsp_virtual_text })
end

ToggleLspVirtualText()
