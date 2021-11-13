if not _G.plugins then
  _G.plugins = {}
end


-- plugins
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

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
  -- use 'puremourning/vimspector'                                 -- multi language graphical debugger

  -- languages
  use 'sheerun/vim-polyglot'                                    -- a collection of language packs for vim
  use 'antoinemadec/vim-verilog-instance'                       -- verilog port instantiation from port declaration
  use 'vhda/verilog_systemverilog.vim'                          -- vim syntax plugin for verilog and systemverilog

  -- movement
  use 'justinmk/vim-sneak'                                      -- jump to any location specified by two characters
  use 'junegunn/vim-easy-align'                                 -- easy alignment of line fields
  use 'mg979/vim-visual-multi'                                  -- multiple cursors
  use 'andymass/vim-matchup'                                    -- replacement for the vim plugin matchit.vim

  -- misc
  use {
    'folke/which-key.nvim',                                     -- space mappings
    config = function() require('config.which_key') end
  }
  use 'antoinemadec/vim-highlight-groups'                       -- add words in highlight groups on the fly
  use 'skywind3000/asyncrun.vim'                                -- run asynchronous bash commands
  use 'tpope/vim-commentary'                                    -- comment stuff out
  use 'tpope/vim-fugitive'                                      -- git wrapper
  use 'tpope/vim-repeat'                                        -- remaps '.' in a way that plugins can tap into it
  use 'tpope/vim-sensible'                                      -- vim defaults that everyone can agree on
  use 'tpope/vim-surround'                                      -- delete, change and add surroundings in pairs
  use 'tpope/vim-abolish'                                       -- work with variations of a word
  use 'antoinemadec/FixCursorHold.nvim'                         -- fix CursorHold perf bug
end)


-- plugin config
if not _G.plugins.config_is_sourced then
  vim.cmd([[
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
  source ~/.vim/plugins_config/vim-polyglot.vim
  source ~/.vim/plugins_config/vim-sneak.vim
  source ~/.vim/plugins_config/vim-startify.vim
  source ~/.vim/plugins_config/vim-surround.vim
  source ~/.vim/plugins_config/vim-visual-multi.vim
]])
  _G.plugins.config_is_sourced = true
end


-- auto compile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])
