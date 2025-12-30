vim.filetype.add({
  extension = {
    v = 'systemverilog',
    svh = 'systemverilog',
    sv = 'systemverilog',
  }
})

local ts_languages = {
  'bash',
  'cpp',
  'cmake',
  'lua',
  'make',
  'python',
  'query',
  'regex',
  'rust',
  'systemverilog',
  'vhdl',
  'vim',
  'vimdoc',
}

require('nvim-treesitter').install(ts_languages)

vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_languages,
  callback = function(ev)
    if vim.api.nvim_buf_line_count(ev.buf) > vim.g.large_file_cutoff then
      return
    end
    vim.treesitter.start()
  end,
})
