local a = vim.api

a.nvim_create_autocmd('VimEnter', {
  callback = function()
    a.nvim_set_hl(0, 'Todo', {
      ctermfg=167,
      fg='#f2594b',
      reverse=true,
      bold=true
    })
    a.nvim_set_hl(0, 'Ignore', {
      ctermfg=236,
      fg='#32302f'
    })
  end
})
