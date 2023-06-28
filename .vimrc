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
set autoindent
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
" appearance
"--------------------------------------------------------------
syntax on

if has('termguicolors') && $TERM_COLORS >= 256
  set termguicolors
else
  set t_Co=256 " vim uses 256 colors
endif
set background=dark
colorscheme desert
