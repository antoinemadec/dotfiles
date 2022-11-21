-- open quickfix window automatically
vim.g.asyncrun_open = 8

vim.api.nvim_create_user_command('Run',
  'AsyncRun <args>', { nargs = "*" })
vim.api.nvim_create_user_command('RunCurrentBuffer',
  'w | execute("Run " . expand("%:p"))', {})
vim.api.nvim_create_user_command('RunAndTimeCurrentBuffer',
  'w | execute("Run time(" . expand("%:p") . ")")', {})
