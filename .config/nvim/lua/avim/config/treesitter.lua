local function disable(lang, bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > vim.g.large_file_cutoff
end

vim.treesitter.language.register('verilog', { 'verilog', 'systemverilog', 'verilog_systemverilog' })

---@diagnostic disable: missing-fields
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'cpp',
    'cmake',
    'lua',
    'make',
    'python',
    'query',
    'regex',
    'rust',
    'verilog',
    'vhdl',
    'vim',
    'vimdoc',
  },
  highlight = {
    enable = true,
    disable = disable,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    disable = disable,
    keymaps = {
      init_selection = '<CR>',
      scope_incremental = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
})
