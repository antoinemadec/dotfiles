local function disable(lang, bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > vim.g.large_file_cutoff
end

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { 'lua', 'cpp', 'python', 'bash', 'rust', 'vim', 'vimdoc', 'query' , 'regex'},
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
}
