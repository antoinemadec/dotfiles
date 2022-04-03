local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd('packadd packer.nvim')
end


require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {'lewis6991/impatient.nvim', config = function() require('impatient') end}

  -- style
  use 'sainnhe/gruvbox-material'                                -- colorscheme
  use {
    'nvim-lualine/lualine.nvim',                                -- status line
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function() require('config.lualine') end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',                      -- display thin vertical lines at each indentation level
    config = function() require('config.indent_blankline') end
  }
  use 'antoinemadec/vim-indentcolor-filetype'                   -- make notes more readable
  use 'mhinz/vim-startify'                                      -- start screen for vim
  use 'RRethy/vim-illuminate'                                   -- highlight other uses of the current word under the cursor
  use {
    'rcarriga/nvim-notify',                                     -- fancy notification manager for NeoVim
    config = function() vim.notify = require('notify') end
  }
  use 'stevearc/dressing.nvim'                                  -- fancy vim.ui.select and input

  -- IDE
  use {
    'neoclide/coc.nvim',                                        -- completion, snippets etc
    branch = 'release'
  }
  use {
    'junegunn/fzf',                                             -- fuzzy search in a dir
    run = './install --all'
  }
  use 'junegunn/fzf.vim'                                        -- fuzzy search in a dir
  use 'antoinemadec/coc-fzf'                                    -- use fzf for coc lists
  use 'honza/vim-snippets'                                      -- snippets working with coc.nvim
  use 'preservim/tagbar'                                        -- display buffer's classes/functions/vars based on ctags
  use 'tpope/vim-fugitive'                                      -- git wrapper
  use {                                                         -- git signs/features
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function() require('config.gitsigns') end
  }
  use {                                                         -- autopair
    'windwp/nvim-autopairs',
    config = function() require('config.nvim-autopairs') end
  }

  -- languages
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {'nvim-treesitter/playground', opt = true},
    config = function() require('config.treesitter') end
  }
  use 'antoinemadec/vim-verilog-instance'                       -- verilog port instantiation from port declaration
  use 'vhda/verilog_systemverilog.vim'                          -- vim syntax plugin for verilog and systemverilog
  use 'MTDL9/vim-log-highlighting'                              -- syntax for log files

  -- movement
  use 'justinmk/vim-sneak'                                      -- jump to any location specified by two characters
  use 'junegunn/vim-easy-align'                                 -- easy alignment of line fields
  use 'mg979/vim-visual-multi'                                  -- multiple cursors
  use {
    'andymass/vim-matchup',                                     -- replacement for the vim plugin matchit.vim
    keys = '%'
  }

  -- misc
  use {
    'folke/which-key.nvim',                                     -- space mappings
    opt = true,
    keys = {"<space>", 'g', '"'},
    config = function() require('config.which_key') end
  }
  use 'antoinemadec/vim-highlight-groups'                       -- add words in highlight groups on the fly
  use 'skywind3000/asyncrun.vim'                                -- run asynchronous bash commands
  use 'tpope/vim-commentary'                                    -- comment stuff out
  use 'tpope/vim-repeat'                                        -- remaps '.' in a way that plugins can tap into it
  use 'tpope/vim-sensible'                                      -- vim defaults that everyone can agree on
  use 'tpope/vim-surround'                                      -- delete, change and add surroundings in pairs
  use 'tpope/vim-abolish'                                       -- work with variations of a word
  use {                                                         -- color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end
  }
  use 'antoinemadec/FixCursorHold.nvim'                         -- fix CursorHold perf bug

  -- automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)


vim.cmd([[
"--------------------------------------------------------------
" plugin
"--------------------------------------------------------------
set rtp+=~/.local/share/nvim/site/pack/packer/start/vim-snippets
source ~/.vim/plugins_config/asyncrun.vim.vim
source ~/.vim/plugins_config/coc.nvim.vim
source ~/.vim/plugins_config/fzf.vim.vim
source ~/.vim/plugins_config/gruvbox-material.vim
source ~/.vim/plugins_config/tagbar.vim
source ~/.vim/plugins_config/verilog_systemverilog.vim.vim
source ~/.vim/plugins_config/vim-fugitive.vim
source ~/.vim/plugins_config/vim-illuminate.vim
source ~/.vim/plugins_config/vim-matchup.vim
source ~/.vim/plugins_config/vim-sneak.vim
source ~/.vim/plugins_config/vim-startify.vim
source ~/.vim/plugins_config/vim-surround.vim
source ~/.vim/plugins_config/vim-visual-multi.vim

augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])
