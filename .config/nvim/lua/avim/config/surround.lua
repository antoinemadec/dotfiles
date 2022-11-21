-- map '-' to 'begin end' surrounding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "verilog_systemverilog",
  command = 'let b:surround_45 = "begin \r end"'
})
