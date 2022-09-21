require 'nvim-treesitter.install'.command_extra_args = {
  cc = { "-std=c99" }
}

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { 'lua', 'cpp', 'python', 'bash', 'rust', 'vim' },
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  matchup = {
    enable = true,
  }
}

-- LSP semantic highlights, only use "Comment" to see undef code
vim.g.coc_default_semantic_highlight_groups = 0
vim.api.nvim_set_hl(0, 'CocSemComment', { link = 'TSComment' })
