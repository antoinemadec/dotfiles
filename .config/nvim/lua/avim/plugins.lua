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

local lazy_opts = {
  ui = {
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "💤 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
}

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
    config = function() require('avim.config.lualine') end
  },
  { -- display thin vertical lines at each indentation level
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    config = function() require('avim.config.indent_blankline') end
  },
  'antoinemadec/vim-indentcolor-filetype', -- make notes more readable
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
  { -- completion, snippets etc
    'neoclide/coc.nvim',
    event = "VeryLazy",
    dependencies = 'honza/vim-snippets',
    branch = 'release',
    config = function() require('avim.config.coc_nvim') end
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
      'fannheyward/telescope-coc.nvim',
      'antoinemadec/telescope-git-browse.nvim',
      'AckslD/nvim-neoclip.lua',
    },
    config = function() require('avim.config.telescope') end
  },
  { -- package manager
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonLog', 'MasonToolsInstall', 'MasonToolsUpdate', 'MasonUninstall', 'MasonUninstallAll' },
    dependencies = { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    config = function() require('avim.config.mason') end
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
    event = "VeryLazy",
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
  {
    'andymass/vim-matchup',
    event = "VeryLazy",
    config = function() require('avim.config.matchup') end
  },

  -- misc
  { -- space mappings
    'folke/which-key.nvim',
    lazy = true,
    keys = { "<space>" },
    config = function() require('avim.config.which_key') end
  },
  'antoinemadec/vim-highlight-groups', -- add words in highlight groups on the fly
  { -- run asynchronous bash commands
    'skywind3000/asyncrun.vim',
    event = "VeryLazy",
    config = function() require('avim.config.asyncrun') end
  },
  { -- comment stuff out
    'numToStr/Comment.nvim',
    event = "VeryLazy",
    config = function() require('avim.config.comment') end
  },
  'tpope/vim-repeat', -- remaps '.' in a way that plugins can tap into it
  { -- delete, change and add surroundings in pairs
    'tpope/vim-surround',
    event = "VeryLazy",
    config = function() require('avim.config.surround') end
  },
  'tpope/vim-abolish', -- work with variations of a word
  { -- color highlighter
    'norcalli/nvim-colorizer.lua',
    event = "VeryLazy",
    config = function() require('colorizer').setup() end
  },
}, lazy_opts)

vim.g.coc_enable_locationlist = 0
vim.api.nvim_create_autocmd("User", {
  pattern = "CocLocationsChange",
  command = "Telescope coc locations"
})
