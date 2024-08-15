require('gitsigns').setup {
  signs_staged_enable = false,
  signs = {
    add          = {text = '│'},
    change       = {text = '│'},
    delete       = {text = '_'},
    topdelete    = {text = '‾'},
    changedelete = {text = '~'},
  },
  on_attach = function(bufnr)
    if vim.api.nvim_buf_get_name(bufnr):match("fugitive") then
      -- Don't attach to specific buffers whose name matches a pattern
      return false
    end
  end,
}
