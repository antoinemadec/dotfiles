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
  if _G.is_large_file() then
    vim.lsp.get_client_by_id(client.id).stop(true)
    return
  end
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
  elseif lsp_server == "pyright" then
    return {
      python = {
        analysis = {
          autoSearchPaths = false,
          useLibraryCodeForTypes = false,
          diagnosticMode = 'openFilesOnly',
        },
      },
    }
  end
  return {}
end

local function get_lsp_filetypes(lsp)
  if lsp == 'verible' then
    return { 'verilog_systemverilog', 'verilog', 'systemverilog' }
  else
    return nil
  end
end

local function get_lsp_cmd(lsp_server)
  if lsp_server == "clangd" then
    return {
      "clangd",
      "--offset-encoding=utf-16",
    }
  end
  return nil
end

for _, lsp in ipairs(_G.lsp_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = get_lsp_settings(lsp),
    filetypes = get_lsp_filetypes(lsp),
    cmd = get_lsp_cmd(lsp),
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

-- lualine flicker bug, see:
-- https://github.com/nvim-lualine/lualine.nvim/issues/886
vim.api.nvim_create_autocmd('LspAttach', {
  command = 'redrawstatus',
})
