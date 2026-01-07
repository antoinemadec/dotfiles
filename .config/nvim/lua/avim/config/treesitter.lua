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

vim.treesitter.language.register('bash', { 'sh' })

local ts_filetypes = {}
for _, lang in ipairs(ts_languages) do
  local fts = vim.treesitter.language.get_filetypes(lang)
  for _, ft in ipairs(fts) do
    if not vim.tbl_contains(ts_filetypes, ft) then
      table.insert(ts_filetypes, ft)
    end
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_filetypes,
  callback = function(ev)
    if vim.api.nvim_buf_line_count(ev.buf) > vim.g.large_file_cutoff then
      return
    end
    vim.treesitter.start()
  end,
})
