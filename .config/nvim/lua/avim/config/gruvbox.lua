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

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    if not _G.is_large_file() then
      vim.hl.on_yank({
        higroup = "Visual",
        timeout = 200
      })
    end
  end
})

vim.g.gruvbox_material_background = 'soft'
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_palette = 'mix'
vim.g.gruvbox_material_show_eob = 0

vim.cmd("colorscheme gruvbox-material")
