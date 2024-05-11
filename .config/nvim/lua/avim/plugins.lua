local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- style
  { -- colorscheme
    'sainnhe/gruvbox-material',
    config = function() require('avim.config.gruvbox') end
  },
  { -- status line
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    cond = not vim.g.man_mode,
    config = function() require('avim.config.statusline') end
  },
  { -- display thin vertical lines at each indentation level
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    config = function() require('avim.config.indent_blankline') end
  },
  { -- make notes more readable
    'antoinemadec/vim-indentcolor-filetype',
  },
  { -- start screen for vim
    'mhinz/vim-startify',
    config = function() require('avim.config.vim-startify') end
  },
  { -- highlight current word under the cursor
    'RRethy/vim-illuminate',
    event = "VeryLazy",
    config = function() require('avim.config.illuminate') end
  },
  { -- fancy notification manager for NeoVim
    'rcarriga/nvim-notify',
    event = "VeryLazy",
    config = function() vim.notify = require('notify') end
  },
  { -- fancy vim.ui.select and input
    'stevearc/dressing.nvim',
    event = "VeryLazy",
  },

  -- IDE
  { -- lsp
    "neovim/nvim-lspconfig",
    dependencies = {
      "j-hui/fidget.nvim", -- lsp progress
    },
    config = function() require('avim.config.lsp') end
  },
  { -- completion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "antoinemadec/cmp-nvim-lsp-signature-help", -- display function signature
      'hrsh7th/cmp-buffer',                       -- buffer source for nvim-cmp
      'hrsh7th/cmp-path',                         -- path source for nvim-cmp
      "hrsh7th/cmp-nvim-lsp",                     -- LSP source for nvim-cmp
      "saadparwaiz1/cmp_luasnip",                 -- snippets source for nvim-cmp
      "L3MON4D3/LuaSnip",                         -- snippets plugin
      "rafamadriz/friendly-snippets",             -- snippet collection
    },
    config = function() require('avim.config.completion') end
  },
  { -- package manager
    'williamboman/mason.nvim',
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function() require('avim.config.mason') end
  },
  {
    'github/copilot.vim',
    event = "VeryLazy",
    init = function() require('avim.config.copilot') end
  },
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      'antoinemadec/telescope-git-browse.nvim',
    },
    config = function() require('avim.config.telescope') end
  },
  { -- debugger
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      config = function() require('avim.config.nvim-dap') end
    },
  },
  { -- display buffer's classes/functions/vars based on ctags
    'preservim/tagbar',
    event = "VeryLazy",
    config = function() require('avim.config.tagbar') end
  },
  { -- git wrapper
    'tpope/vim-fugitive',
    event = "VeryLazy",
    config = function() require('avim.config.fugitive') end
  },
  { -- git signs/features
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('avim.config.gitsigns') end
  },
  { -- autopair
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function() require('avim.config.nvim-autopairs') end
  },

  -- languages
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function() require('avim.config.treesitter') end
  },
  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSCaptureUnderCursor' }
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = "VeryLazy",
    config = function() require('avim.config.treesitter_context') end
  },
  { -- verilog port instantiation from port declaration
    'antoinemadec/vim-verilog-instance',
    event = "VeryLazy",
  },
  { -- vim syntax plugin for verilog and systemverilog
    'vhda/verilog_systemverilog.vim',
    lazy = true,
    ft = 'verilog_systemverilog',
    init = require('avim.config.verilog_systemverilog').setup,
    config = require('avim.config.verilog_systemverilog').config
  },
  'MTDL9/vim-log-highlighting', -- syntax for log files

  -- movement
  { -- move windows around
    'antoinemadec/window-movement.nvim',
    lazy = true,
  },
  { -- jump to any location specified by two characters
    'folke/flash.nvim',
    event = "VeryLazy",
    ---@type Flash.Config
    opts = require('avim.config.flash').opts,
    keys = require('avim.config.flash').keys,
  },
  { -- easy alignment of line fields
    'junegunn/vim-easy-align',
    event = "VeryLazy",
  },
  { -- multiple cursors
    'mg979/vim-visual-multi',
    event = "VeryLazy",
    config = function() require('avim.config.vim_visual_multi') end
  },

  -- misc
  { -- space mappings
    'folke/which-key.nvim',
    lazy = true,
    keys = { "<space>" },
    config = function() require('avim.config.which_key') end
  },
  { -- add words in highlight groups on the fly
    'antoinemadec/vim-highlight-groups',
  },
  { -- file explorer
    'stevearc/oil.nvim',
    config = function() require('avim.config.oil') end
  },
  { -- run asynchronous bash commands
    'skywind3000/asyncrun.vim',
    event = "VeryLazy",
    config = function() require('avim.config.asyncrun') end
  },
  { -- remaps '.' in a way that plugins can tap into it
    'tpope/vim-repeat',
  },
  { -- delete, change and add surroundings in pairs
    'tpope/vim-surround',
    event = "VeryLazy",
    config = function() require('avim.config.surround') end
  },
  { -- work with variations of a word
    'tpope/vim-abolish',
    event = "VeryLazy",
  },
  { -- color highlighter
    'norcalli/nvim-colorizer.lua',
    event = "VeryLazy",
    config = function() require('colorizer').setup() end
  },
  { -- mardown preview
    'iamcco/markdown-preview.nvim',
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  }
})
