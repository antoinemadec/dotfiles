local a = vim.api

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

local function on_attach(client, _)
  if _G.is_large_file() then
    vim.lsp.get_client_by_id(client.id).stop(true)
    return
  end
  vim.bo.tagfunc = nil -- don't overwrite ctags mappings/functions with LSP
  if client.server_capabilities.documentSymbolProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = 0,
      callback = _G.LUtils.update_current_function,
    })
  else
    vim.b.lsp_current_function = ''
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function get_lsp_settings(lsp_server)
  if lsp_server == "lua_ls" then
    local nvim_runtime_dirs = a.nvim_get_runtime_file("", true)
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
vim.diagnostic.config({ severity_sort = true })

a.nvim_create_autocmd('VimEnter', {
  callback = function()
    local signs = { Error = ">>", Warn = ">>", Hint = ">>", Info = ">>" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      local vhl = "DiagnosticVirtualText" .. type
      local vhl_table = a.nvim_get_hl(0, { name = hl, link = false })
      vhl_table.fg = _G.dim_color(vhl_table.fg, 80)
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      a.nvim_set_hl(0, vhl, vhl_table)
    end
  end
})

local lsp_virtual_text = true
function _G.ToggleLspVirtualText()
  lsp_virtual_text = not lsp_virtual_text
  vim.diagnostic.config({ virtual_text = lsp_virtual_text })
end

ToggleLspVirtualText()

-- lsp progress
require("fidget").setup {
  notification = {
    window = {
      x_padding = 0,              -- Padding from right edge of window boundary
    },
  },
}

-- lualine flicker bug, see:
-- https://github.com/nvim-lualine/lualine.nvim/issues/886
a.nvim_create_autocmd('LspAttach', {
  command = 'redrawstatus',
})
