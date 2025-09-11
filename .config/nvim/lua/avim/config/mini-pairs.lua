require('mini.pairs').setup()

local function unmap_sv()
  vim.keymap.set('i', '`', '`', { buffer = true })
  vim.keymap.set('i', "'", "'", { buffer = true })
end

vim.api.nvim_create_autocmd(
  'FileType',
  { pattern = 'systemverilog', callback = unmap_sv }
)
