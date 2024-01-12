require('illuminate').configure({
  delay = 100,
  filetypes_denylist = {
    'list',
  },
  large_file_cutoff = vim.g.large_file_cutoff,
})
