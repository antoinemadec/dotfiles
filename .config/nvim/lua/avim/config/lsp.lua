local a = vim.api

_G.lsp_servers = {
  'bashls',
  'clangd',
  'lua_ls',
  'gitlab-ls',
  'pyright',
  'verible',
}

-- add mason bin dir in the PATH to find LSP bin even in Mason is not loaded yet
local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin_path .. ":" .. vim.env.PATH

local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

vim.lsp.config('*', {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = { '.git' },
})
vim.lsp.enable(_G.lsp_servers)

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
      local vt_hl = "DiagnosticVirtualText" .. type
      local vl_hl = "DiagnosticVirtualLines" .. type
      local vhl_table = a.nvim_get_hl(0, { name = hl, link = false })
      vhl_table.fg = _G.dim_color(vhl_table.fg, 80)
      a.nvim_set_hl(0, vt_hl, vhl_table)
      a.nvim_set_hl(0, vl_hl, vhl_table)
    end
    -- hide all semantic highlights
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end
  end
})

local lsp_virtual_text = false
function _G.ToggleLspVirtualText()
  lsp_virtual_text = not lsp_virtual_text
  vim.diagnostic.config({ virtual_lines = lsp_virtual_text })
end

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
