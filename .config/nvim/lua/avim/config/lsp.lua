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

local capabilities = require('blink.cmp').get_lsp_capabilities()

local function on_attach(client, bufnr)
  if _G.is_large_file(bufnr) then
    vim.schedule(function()
      vim.lsp.buf_detach_client(bufnr, client.id)
    end)
    return
  end
  vim.bo.tagfunc = nil -- don't overwrite ctags mappings/functions with LSP
end

vim.lsp.config('*', {
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = { '.git' },
  root_dir = function(bufnr, on_dir)
    -- disable LSP for
    --    - large files
    --    - fugitve buffers
    if not (vim.g.lsp_disabled or _G.is_large_file(bufnr) or vim.api.nvim_buf_get_name(bufnr):match('^fugitive://')) then
      on_dir(vim.fn.getcwd())
    end
  end,
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

-- lsp commands
local function lsp_client_names(name)
  return vim.iter(vim.lsp.get_clients({ name = name }))
      :map(function(c) return c.name end)
      :unique()
      :totable()
end

vim.api.nvim_create_user_command(
  'LspStart',
  function(kwargs)
    -- re-enabling fires FileType on loaded buffers, (re)starting missing clients
    local name = kwargs.fargs[1]
    vim.lsp.enable(name or _G.lsp_servers)
  end,
  {
    nargs = "?",
    complete = function()
      return vim.tbl_map(function(c) return c end, _G.lsp_servers)
    end
  }
)

vim.api.nvim_create_user_command(
  'LspStop',
  function(kwargs)
    local name = kwargs.fargs[1]
    for _, client in ipairs(vim.lsp.get_clients({ name = name })) do
      print("LSP:", client.name, "stop")
      client:stop()
    end
  end,
  {
    nargs = "?",
    complete = function()
      return lsp_client_names()
    end
  }
)

vim.api.nvim_create_user_command(
  "LspRestart",
  function(kwargs)
    for _, name in ipairs(lsp_client_names(kwargs.fargs[1])) do
      print("LSP:", name, "restart")
      -- copilot.vim tracks its client id, let it restart its own client
      if name == "GitHub Copilot" then
        vim.cmd("silent Copilot restart")
      else
        vim.cmd.lsp({ args = { "restart", name } })
      end
    end
  end,
  {
    nargs = "?",
    complete = function()
      return lsp_client_names()
    end
  }
)

vim.api.nvim_create_user_command(
  "LspInfo",
  function()
    vim.cmd('checkhealth vim.lsp')
  end,
  {}
)

vim.api.nvim_create_user_command(
  "LspLog",
  function()
    vim.cmd('tabnew ' .. vim.lsp.log.get_filename())
  end,
  {}
)
