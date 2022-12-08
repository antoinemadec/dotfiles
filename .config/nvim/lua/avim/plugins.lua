local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
  vim.cmd('packadd packer.nvim')
end

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim'

  -- style
  use { -- colorscheme
    'sainnhe/gruvbox-material',
    config = function() require('avim.config.gruvbox') end
  }
  use { -- status line
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('avim.config.lualine') end
  }
  use { -- display thin vertical lines at each indentation level
    'lukas-reineke/indent-blankline.nvim',
    config = function() require('avim.config.indent_blankline') end
  }
  use 'antoinemadec/vim-indentcolor-filetype' -- make notes more readable
  use { -- start screen for vim
    'mhinz/vim-startify',
    config = function() require('avim.config.vim-startify') end
  }
  use { -- highlight current word under the cursor
    'RRethy/vim-illuminate',
    config = function() require('avim.config.illuminate') end
  }
  use { -- fancy notification manager for NeoVim
    'rcarriga/nvim-notify',
    config = function() vim.notify = require('notify') end
  }
  use 'stevearc/dressing.nvim' -- fancy vim.ui.select and input

  -- IDE
  use { -- completion, snippets etc
    'neoclide/coc.nvim',
    branch = 'release',
    config = function() require('avim.config.coc_nvim') end
  }
  use {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
      'fannheyward/telescope-coc.nvim',
      'antoinemadec/telescope-git-browse.nvim',
      'AckslD/nvim-neoclip.lua',
    },
    config = function() require('avim.config.telescope') end
  }
  use { -- snippets working with coc.nvim
    'honza/vim-snippets',
    rtp = '~/.local/share/nvim/site/pack/packer/start/vim-snippets'
  }
  use { -- package manager
    'williamboman/mason.nvim',
    requires = { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    config = function() require('avim.config.mason') end
  }
  use { -- debugger
    "rcarriga/nvim-dap-ui",
    opt = true,
    module = { 'dap', 'dap-ui' },
    requires = {
      "mfussenegger/nvim-dap",
      module = { 'dap', 'dap-ui' },
    },
    config = function() require('avim.config.nvim-dap') end
  }
  use { -- display buffer's classes/functions/vars based on ctags
    'preservim/tagbar',
    config = function() require('avim.config.tagbar') end
  }
  use { -- git wrapper
    'tpope/vim-fugitive',
    config = function() require('avim.config.fugitive') end
  }
  use { -- git signs/features
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('avim.config.gitsigns') end
  }
  use { -- autopair
    'windwp/nvim-autopairs',
    config = function() require('avim.config.nvim-autopairs') end
  }

  -- languages
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/playground',
      opt = true,
      cmd = { 'TSPlaygroundToggle', 'TSCaptureUnderCursor' }
    },
    config = function() require('avim.config.treesitter') end
  }
  use {
    'nvim-treesitter/nvim-treesitter-context',
    config = function() require('avim.config.treesitter_context') end
  }
  use 'antoinemadec/vim-verilog-instance' -- verilog port instantiation from port declaration
  use { -- vim syntax plugin for verilog and systemverilog
    'vhda/verilog_systemverilog.vim',
    opt = true,
    ft = 'verilog_systemverilog',
    setup = require('avim.config.verilog_systemverilog').setup,
    config = require('avim.config.verilog_systemverilog').config
  }
  use 'MTDL9/vim-log-highlighting' -- syntax for log files

  -- movement
  use { -- jump to any location specified by two characters
    'ggandor/leap.nvim',
    requires = { 'ggandor/flit.nvim' },
    config = function() require('avim.config.leap') end
  }
  use 'junegunn/vim-easy-align' -- easy alignment of line fields
  use { -- multiple cursors
    'mg979/vim-visual-multi',
    config = function() require('avim.config.vim_visual_multi') end
  }
  use {
    'andymass/vim-matchup',
    config = function() require('avim.config.matchup') end
  }

  -- misc
  use { -- space mappings
    'folke/which-key.nvim',
    opt = true,
    keys = { "<space>" },
    config = function() require('avim.config.which_key') end
  }
  use 'antoinemadec/vim-highlight-groups' -- add words in highlight groups on the fly
  use { -- run asynchronous bash commands
    'skywind3000/asyncrun.vim',
    config = function() require('avim.config.asyncrun') end
  }
  use { -- comment stuff out
    'numToStr/Comment.nvim',
    config = function() require('avim.config.comment') end
  }
  use 'tpope/vim-repeat' -- remaps '.' in a way that plugins can tap into it
  use { -- delete, change and add surroundings in pairs
    'tpope/vim-surround',
    config = function() require('avim.config.surround') end
  }
  use 'tpope/vim-abolish' -- work with variations of a word
  use { -- color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end
  }

  -- automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

vim.g.coc_enable_locationlist = 0
vim.api.nvim_create_autocmd("User", {
  pattern = "CocLocationsChange",
  command = "Telescope coc locations"
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("packer_user_config", {}),
  pattern = "plugins.lua",
  command = "source <afile> | PackerSync"
})
