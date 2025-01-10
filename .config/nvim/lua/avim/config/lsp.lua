local a = vim.api

_G.lsp_servers = {
  'bashls',
  'clangd',
  'lua_ls',
  'pyright',
  -- 'rust_analyzer',
  -- 'ts_ls',
  'verible',
}

-- add mason bin dir in the PATH to find LSP bin even in Mason is not loaded yet
local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin_path .. ":" .. vim.env.PATH

-- lspconfig
local lspconfig = require('lspconfig')

local function on_attach(client, bufnr)
  if _G.is_large_file() then
    vim.schedule(function()
      vim.lsp.buf_detach_client(bufnr, client.id)
    end)
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
  if lsp_server == "pyright" then
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
vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '>>',
      [vim.diagnostic.severity.WARN] = '>>',
      [vim.diagnostic.severity.HINT] = '>>',
      [vim.diagnostic.severity.INFO] = '>>',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
    },
  },
})

a.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- set diagnostic virtual text highlight
    for _, type in pairs({ 'Error', 'Warn', 'Hint', 'Info' }) do
      local hl = "DiagnosticSign" .. type
      local vhl = "DiagnosticVirtualText" .. type
      local vhl_table = a.nvim_get_hl(0, { name = hl, link = false })
      vhl_table.fg = _G.dim_color(vhl_table.fg, 80)
      a.nvim_set_hl(0, vhl, vhl_table)
    end
    -- hide all semantic highlights
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
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
  progress = {
    suppress_on_insert = true,   -- Suppress new messages while in insert mode
    ignore_done_already = true,  -- Ignore new tasks that are already complete
    ignore_empty_message = true, -- Ignore new tasks that don't contain a message
  },
  notification = {
    window = {
      x_padding = 0, -- Padding from right edge of window boundary
    },
  },
}
