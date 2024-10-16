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

-- don't use treesitter <CR> remap in the command window
vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<CR>', '<CR>' , opts)
  end,
})

-- set the syntax to get highlighting in the command window (q: and friends)
vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '[:>]',
  desc = 'If the treesitter vim parser is installed, set the syntax again to get highlighting in the command window',
  group = vim.api.nvim_create_augroup('cmdwin_syntax', {}),
  callback = function ()
    local is_loadable, _ = pcall(vim.treesitter.language.add, 'vim')
    if is_loadable then
      vim.cmd('set syntax=vim')
    end
  end
})

require("cmdline-hl").setup()
