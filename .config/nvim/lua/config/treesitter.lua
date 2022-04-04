require'nvim-treesitter.configs'.setup {
  ensure_installed = {'lua', 'cpp', 'python', 'bash', 'rust'},
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- colorscheme plugin might set Coc semantic highlights,
-- make sure to disable them in order not to conflict with TS highlights
vim.highlight.link('CocSem_angle', 'NONE', true)
vim.highlight.link('CocSem_annotation', 'NONE', true)
vim.highlight.link('CocSem_attribute', 'NONE', true)
vim.highlight.link('CocSem_bitwise', 'NONE', true)
vim.highlight.link('CocSem_boolean', 'NONE', true)
vim.highlight.link('CocSem_brace', 'NONE', true)
vim.highlight.link('CocSem_bracket', 'NONE', true)
vim.highlight.link('CocSem_builtinAttribute', 'NONE', true)
vim.highlight.link('CocSem_builtinType', 'NONE', true)
vim.highlight.link('CocSem_character', 'NONE', true)
vim.highlight.link('CocSem_class', 'NONE', true)
vim.highlight.link('CocSem_colon', 'NONE', true)
vim.highlight.link('CocSem_comma', 'NONE', true)
vim.highlight.link('CocSem_comment', 'NONE', true)
vim.highlight.link('CocSem_comparison', 'NONE', true)
vim.highlight.link('CocSem_constParameter', 'NONE', true)
vim.highlight.link('CocSem_dependent', 'NONE', true)
vim.highlight.link('CocSem_dot', 'NONE', true)
vim.highlight.link('CocSem_enum', 'NONE', true)
vim.highlight.link('CocSem_enumMember', 'NONE', true)
vim.highlight.link('CocSem_escapeSequence', 'NONE', true)
vim.highlight.link('CocSem_event', 'NONE', true)
vim.highlight.link('CocSem_formatSpecifier', 'NONE', true)
vim.highlight.link('CocSem_function', 'NONE', true)
vim.highlight.link('CocSem_interface', 'NONE', true)
vim.highlight.link('CocSem_keyword', 'NONE', true)
vim.highlight.link('CocSem_label', 'NONE', true)
vim.highlight.link('CocSem_logical', 'NONE', true)
vim.highlight.link('CocSem_macro', 'NONE', true)
vim.highlight.link('CocSem_method', 'NONE', true)
vim.highlight.link('CocSem_modifier', 'NONE', true)
vim.highlight.link('CocSem_namespace', 'NONE', true)
vim.highlight.link('CocSem_number', 'NONE', true)
vim.highlight.link('CocSem_operator', 'NONE', true)
vim.highlight.link('CocSem_parameter', 'NONE', true)
vim.highlight.link('CocSem_parenthesis', 'NONE', true)
vim.highlight.link('CocSem_property', 'NONE', true)
vim.highlight.link('CocSem_punctuation', 'NONE', true)
vim.highlight.link('CocSem_regexp', 'NONE', true)
vim.highlight.link('CocSem_selfKeyword', 'NONE', true)
vim.highlight.link('CocSem_semicolon', 'NONE', true)
vim.highlight.link('CocSem_string', 'NONE', true)
vim.highlight.link('CocSem_struct', 'NONE', true)
vim.highlight.link('CocSem_type', 'NONE', true)
vim.highlight.link('CocSem_typeAlias', 'NONE', true)
vim.highlight.link('CocSem_typeParameter', 'NONE', true)
vim.highlight.link('CocSem_variable', 'NONE', true)
