-- avoid extra statusline line when in cmdline
vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    require('lualine').hide()
    vim.opt.laststatus = 0
    vim.cmd [[
set laststatus=0
hi! link StatusLine WinSeparator
hi! link StatusLineNC WinSeparator
set statusline=%{repeat('─',winwidth('.'))}
    ]]
  end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    require('lualine').hide({ unhide = true })
    vim.opt.laststatus = 3
  end,
})

require("cmdline-hl").setup()
