" environement variables used:
"   TERM_COLORS           : enable termguicolors if >= 256
"   TERM_FANCY_CURSOR     : enable thin insert cursor if 'true'
"   TERM_BRACKETED_PASTE  : disable bracketed paste if not 'true'

"--------------------------------------------------------------
" plugins
"--------------------------------------------------------------
let g:polyglot_disabled = ['v', 'python-compiler', 'autoindent']
call plug#begin('~/.vim/plugins')
" style
Plug 'sainnhe/gruvbox-material'                                " colorscheme
Plug 'itchyny/lightline.vim'                                   " status line
Plug 'yggdroot/indentline'                                     " display thin vertical lines at each indentation level
Plug 'antoinemadec/vim-indentcolor-filetype'                   " make notes more readable
Plug 'mhinz/vim-startify'                                      " start screen for vim
Plug 'ryanoasis/vim-devicons'                                  " add icons to your plugins
Plug 'RRethy/vim-illuminate'                                   " highlight other uses of the current word under the cursor
" IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}                " completion, snippets etc
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'} " fuzzy search in a dir
Plug 'junegunn/fzf.vim'                                        " fuzzy search in a dir
Plug 'antoinemadec/coc-fzf'                                    " use fzf for coc lists
Plug 'honza/vim-snippets'                                      " snippets working with coc.nvim
Plug 'preservim/tagbar'                                        " display buffer's classes/functions/vars based on ctags
" Plug 'puremourning/vimspector'                                 " multi language graphical debugger
" languages
Plug 'sheerun/vim-polyglot'                                    " a collection of language packs for vim
Plug 'antoinemadec/vim-verilog-instance'                       " verilog port instantiation from port declaration
Plug 'vhda/verilog_systemverilog.vim'                          " vim syntax plugin for verilog and systemverilog
" movement
Plug 'justinmk/vim-sneak'                                      " jump to any location specified by two characters
Plug 'junegunn/vim-easy-align'                                 " easy alignment of line fields
Plug 'mg979/vim-visual-multi'                                  " multiple cursors
Plug 'andymass/vim-matchup'                                    " replacement for the vim plugin matchit.vim
" misc
Plug 'liuchengxu/vim-which-key'                                " space mappings
Plug 'antoinemadec/vim-highlight-groups'                       " add words in highlight groups on the fly
Plug 'skywind3000/asyncrun.vim'                                " run asynchronous bash commands
Plug 'tpope/vim-commentary'                                    " comment stuff out
Plug 'tpope/vim-fugitive'                                      " git wrapper
Plug 'tpope/vim-repeat'                                        " remaps '.' in a way that plugins can tap into it
Plug 'tpope/vim-sensible'                                      " vim defaults that everyone can agree on
Plug 'tpope/vim-surround'                                      " delete, change and add surroundings in pairs
Plug 'tpope/vim-abolish'                                       " work with variations of a word
Plug 'antoinemadec/FixCursorHold.nvim'                         " fix CursorHold perf bug
call plug#end()

if empty(glob("~/.vim/plugins"))
  PlugInstall
endif

"--------------------------------------------------------------
" vim options
"--------------------------------------------------------------
set nocompatible               " get rid of vi compatibility
set cb=unnamed,unnamedplus     " use * and + registers for yank
set mouse=a                    " allow to resize and copy/paste without selecting text outside of the window
set nobackup                   " don't keep a backup file
set textwidth=0                " don't wrap words by default
set wildmode=longest:full,full " wildchar completion mode
set hlsearch                   " highlight search
set expandtab                  " tab expand to space
set tabstop=2                  " number of spaces that a <Tab> in the file counts for
set shiftwidth=2               " number of spaces to use for each step of (auto)indent
set isfname-=,                 " don't try to match certain characters in filename
set isfname-==                 " don't try to match certain characters in filename
set number relativenumber      " show the line number relative to the line with the cursor
set title                      " change terminal title
set timeoutlen=500             " time in milliseconds to wait for a mapped sequence to complete
set ttimeoutlen=50             " ms waited for a key code/sequence to complete. Allow faster insert to normal mode
set complete=.,w,b,u           " specifies how keyword completion works when CTRL-P or CTRL-N are used
set noshowcmd                  " don't show (partial) command in the last line of the screen
set ignorecase smartcase       " pattern with at least one uppercase character: search becomes case sensitive
set cscopetag                  " cstag performs the equivalent of tjump when searching through tags file
set cscopetagorder=1           " tag files searched before cscopte database
set cscoperelative             " basename of cscope.out is be used as the prefix
set tags+=../tags;             " get tags even if the current file is a symbolic/hard link
set sessionoptions+=localoptions,globals " all options and mappings
set completeopt+=menuone,longest
" complete preview popup
set t_ut=                      " do not use term color for clearing
if $TERM_FANCY_CURSOR == 'true'
  let &t_SI = "\e[6 q"         " allow thin cursor in insert mode
  let &t_EI = "\e[2 q"         " allow thin cursor in insert mode
else
  let &t_SI = ""
  let &t_EI = ""
  let &t_SH = ""
  set guicursor=
endif
if $TERM_BRACKETED_PASTE != 'true'
  let &t_BE = ''
endif

"--------------------------------------------------------------
" common with neovim
"--------------------------------------------------------------
source ~/.vim/vimrc_common

"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
source ~/.vim/my_mappings.vim

"--------------------------------------------------------------
" misc
"--------------------------------------------------------------
" start vim server
if exists('*remote_startserver') && has('clientserver') && v:servername == ''
  call remote_startserver('vim_server_' . getpid())
endif

" windows options
if has('win32') && filereadable($HOME.'\.vim\windows.vim')
  source ~/.vim/windows.vim
endif

" SystemVerilog
autocmd FileType verilog_systemverilog setlocal commentstring=//%s
let g:uvm_tags_is_on = 0
let g:uvm_tags_path = "~/.vim/tags/UVM_CDNS-1.2"
command! ToggleUVMTags call ToggleUVMTags()
function ToggleUVMTags()
  if g:uvm_tags_is_on
    exe 'set tags-=' . g:uvm_tags_path
  else
    exe 'set tags+=' . g:uvm_tags_path
  endif
  let g:uvm_tags_is_on = !g:uvm_tags_is_on
  echo "UVM tags = " . g:uvm_tags_is_on
endfunction

function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_old_idx = tabpagenr()
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if tabpagenr() == l:tab_old_idx
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

" repeat last change at a column index
function! DotAtColumnIndex(cidx)
  let a = a:cidx - 1
  execute "normal " . a . "l."
endfunction

" gui/not gui specific options
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ 10
  " simple gvim
  set guioptions-=m "remove menu bar
  set guioptions-=T "remove toolbar
  set guioptions-=r "remove right-hand scroll bar
  set guioptions-=L "remove left-hand scroll bar
  " shift insert
  map  <silent>  <S-Insert>  "+p
  imap <silent>  <S-Insert>  <Esc>"+pa
endif

