" environement variables used:
"   TERM_ITALICS          : enable italic capabilites if 'true'
"   TERM_COLORS           : enable termguicolors if >= 256
"   TERM_FANCY_CURSOR     : enable thin insert cursor if 'true'
"   TERM_BRACKETED_PASTE  : disable bracketed paste if not 'true'
"   CSCOPE_DB             : cscope database

"--------------------------------------------------------------
" plugins
"--------------------------------------------------------------
call plug#begin('~/.vim/plugins')
Plug 'gruvbox-community/gruvbox'                                  " colorscheme
Plug 'itchyny/lightline.vim'                                      " status line
Plug 'junegunn/fzf',
      \ {'dir': '~/.fzf','do': './install --all --no-completion'} " fuzzy search in a dir
Plug 'junegunn/fzf.vim'                                           " fuzzy search in a dir
Plug 'junegunn/vim-easy-align'                                    " easy alignment of line fields
Plug 'antoinemadec/vim-highlight-groups'                          " add words in highlight groups on the fly
Plug 'tpope/vim-fugitive'                                         " Git wrapper
Plug 'tpope/vim-surround'                                         " delete, change and add surroundings in pairs
Plug 'tpope/vim-commentary'                                       " comment stuff out
Plug 'tpope/vim-sensible'                                         " vim defaults that everyone can agree on
Plug 'tpope/vim-speeddating'                                      " use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'tpope/vim-repeat'                                           " remaps '.' in a way that plugins can tap into it
Plug 'skywind3000/asyncrun.vim'                                   " run asynchronous bash commands
Plug 'kana/vim-textobj-user'                                      " needed to add text object
Plug 'kana/vim-textobj-line'                                      " add line text object for motion like 'dil'
Plug 'kana/vim-textobj-indent'                                    " add indent text object for motion like 'dii'
Plug 'terryma/vim-multiple-cursors'                               " Sublime Text's multiple selection feature
Plug 'chamindra/marvim'                                           " store/load macros easily
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}                  " display buffer's classes/functions/vars based on ctags
Plug 'mhinz/vim-startify'                                         " start screen for Vim
Plug 'ryanoasis/vim-devicons'                                     " add icons to your plugins
Plug 'Yggdroot/indentLine'                                        " display thin vertical lines at each indentation level
Plug 'andymass/vim-matchup'                                       " replacement for the vim plugin matchit.vim
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}              " file explorer
Plug 'honza/vim-snippets'                                         " snippets working with coc.nvim
" filetype specific
Plug 'sheerun/vim-polyglot', {'do': './build'}                    " a collection of language packs for Vim
Plug 'neoclide/coc.nvim',
      \ {'do': 'yarn install --frozen-lockfile'}                  " completion, snippets etc
Plug 'antoinemadec/coc-fzf'
Plug 'vhda/verilog_systemverilog.vim',
      \ {'for': 'verilog_systemverilog'}                          " Vim Syntax Plugin for Verilog and SystemVerilog
Plug 'antoinemadec/vim-verilog-instance',
      \ {'for': 'verilog_systemverilog'}                          " Verilog port instantiation from port declaration
Plug 'antoinemadec/vim-indentcolor-filetype'                      " make notes more readable
call plug#end()

if empty(glob("~/.vim/plugins"))
  PlugInstall
endif

"--------------------------------------------------------------
" vim options
"--------------------------------------------------------------
set nocompatible               " get rid of vi compatibility
set clipboard=unnamed          " unnamed register is same as *
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
" highlight current line
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
set number relativenumber    " show the line number relative to the line with the cursor
if has('nvim')
  au TermOpen * setlocal nonumber norelativenumber
  set inccommand=nosplit
endif
set title                      " change terminal title
set ttimeoutlen=50             " ms waited for a key code/sequence to complete. Allow faster insert to normal mode
set complete=.,w,b,u           " specifies how keyword completion works when CTRL-P or CTRL-N are used
set showcmd                    " in Visual mode the size of the selected area is shown
set ignorecase smartcase       " pattern with at least one uppercase character: search becomes case sensitive
set cscopetag                  " cstag performs the equivalent of tjump when searching through tags file
set cscopetagorder=1           " tag files searched before cscopte database
set cscoperelative             " basename of cscope.out is be used as the prefix
set completeopt+=menuone,longest
" complete preview popup
if !has('nvim')
  set completeopt+=popup
  set completepopup+=border:off,highlight:PmenuThumb
endif
set t_ut=                      " do not use term color for clearing
if $TERM_FANCY_CURSOR == 'true'
  let &t_SI = "\e[6 q"         " allow thin cursor in insert mode
  let &t_EI = "\e[2 q"         " allow thin cursor in insert mode
else
  let &t_SI = ""
  let &t_EI = ""
  let &t_SH = ""
endif
if $TERM_BRACKETED_PASTE != 'true'
  let &t_BE = ''
endif

"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
source ~/.vim/my_mappings.vim

"--------------------------------------------------------------
" appearance
"--------------------------------------------------------------
if has('termguicolors') && $TERM_COLORS >= 256
  set termguicolors
  let hg0 = 13
  let hg1 = 17
else
  set t_Co=256 " vim uses 256 colors
  let hg0 = 4
  let hg1 = 6
endif
set background=dark
let g:gruvbox_contrast_dark = 'soft'
colorscheme gruvbox
highlight Todo      term=standout cterm=bold ctermfg=235 ctermbg=167 gui=bold guifg=#282828 guibg=#fb4934
highlight VertSplit guibg=#32302f guifg=#181A1F
set fillchars=vert:│,fold:+

"--------------------------------------------------------------
" plugins config
"--------------------------------------------------------------
for plugin in keys(g:plugs)
  let s:plugin_config = $HOME . '/.vim/plugins_config/' . plugin .'.vim'
  if filereadable(s:plugin_config)
    execute 'source ' . s:plugin_config
  endif
endfor

"--------------------------------------------------------------
" highlighting
"--------------------------------------------------------------
function ToggleTrailingSpace()
  let l:nr = winnr()
  if &list
    windo set nolist
    highlight CustomHighlight_TrailingSpace NONE
  else
    windo set list
    highlight CustomHighlight_TrailingSpace term=standout cterm=bold ctermfg=235 ctermbg=167 gui=bold guifg=#282828 guibg=#fb4934
  endif
  exe l:nr . "wincmd w"
  call lightline#update()
endfunction
call ToggleTrailingSpace()

autocmd BufWinEnter * match CustomHighlight_TrailingSpace /\s\+$/
autocmd InsertEnter * match CustomHighlight_TrailingSpace /\s\+\%#\@<!$/
autocmd InsertLeave * match CustomHighlight_TrailingSpace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" highlight non breakable space
set listchars=nbsp:?

" always highlight TBD TODO and FIXME no matter the filetype
highlight link CustomHighlight_Warning Todo
autocmd WinEnter,VimEnter * :silent! call matchadd('CustomHighlight_Warning', 'TBD\|TODO\|FIXME', -1)

"--------------------------------------------------------------
" folding
"--------------------------------------------------------------
set foldmethod=indent
set nofoldenable
set foldnestmax=9
set foldlevelstart=9
nmap <silent> zi :call ToggleFoldEnable()<CR>
nmap <silent> zm :call NormalFoldCmd("zm")<CR>
nmap <silent> zM :call NormalFoldCmd("zM")<CR>
nmap <silent> zr :call NormalFoldCmd("zr")<CR>
nmap <silent> zR :call NormalFoldCmd("zR")<CR>
nmap <silent> zc :call NormalFoldCmd("zc")<CR>
nmap <silent> zC :call NormalFoldCmd("zC")<CR>
nmap <silent> zo :call NormalFoldCmd("zo")<CR>
nmap <silent> zO :call NormalFoldCmd("zO")<CR>

function NormalFoldCmd(cmd)
  if &foldenable == 0
    call ToggleFoldEnable()
  endif
  execute "unmap " .  a:cmd
  execute "normal " . a:cmd
  call lightline#update()
  execute "nmap <silent> " . a:cmd . " :call NormalFoldCmd(\"" . a:cmd . "\")<CR>"
endfunction

function! ToggleFoldEnable()
  let cur_foldlevel = &foldlevel
  set foldenable!
  if &foldenable
    " get max foldlevel and set foldcolumn accordingly,
    " min foldcolumn = 6
    execute "normal zR"
    let &foldcolumn = &foldlevel + 1
    if &foldcolumn < 6
      let &foldcolumn = 6
    endif
    " set back previous foldlevel, make sure it is in
    " [0:max(foldlevel)]
    if cur_foldlevel > &foldlevel
      let cur_foldlevel = &foldlevel
    endif
    let &foldlevel = cur_foldlevel
  else
    set foldcolumn=0
  endif
  call lightline#update()
endfunction

"--------------------------------------------------------------
" language specific
"--------------------------------------------------------------
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

" c cpp c++
autocmd FileType c,cpp setlocal shiftwidth=4 tabstop=4
if filereadable("cscope.out")
  cs add cscope.out
elseif $CSCOPE_DB != ""
  cs add $CSCOPE_DB
endif

" c#
autocmd FileType cs setlocal shiftwidth=4 tabstop=4

" java
autocmd FileType java setlocal shiftwidth=4 tabstop=4

"--------------------------------------------------------------
" terminal
"--------------------------------------------------------------
if has('terminal')
  command! T  call term_start(&shell, {"term_kill": "term", "term_finish": "close", "curwin": 1})
  command! TS call term_start(&shell, {"term_kill": "term", "term_finish": "close"})
  command! TV call term_start(&shell, {"term_kill": "term", "term_finish": "close", "vertical": 1})
  command! TT tab call term_start(&shell, {"term_kill": "term", "term_finish": "close"})
elseif has('nvim')
  command! T terminal
  command! TS split | terminal
  command! TV vsplit | terminal
  command! TT tabe | terminal
endif

"--------------------------------------------------------------
" misc
"--------------------------------------------------------------
" start vim server
if exists('*remote_startserver') && has('clientserver') && v:servername == ''
  call remote_startserver('vim_server_' . getpid())
endif

function! GetCurrentBufferDir()
  if exists("b:netrw_browser_active")
    return b:netrw_curdir
  elseif expand('%') == "" || &buftype ==# 'terminal'
    return "."
  else
    return expand('%:h')
  endif
endfunction

" redirection of vim commands in clipboard
command! -nargs=1 RediCmdToClipboard call RediCmdToClipboard(<f-args>)
function! RediCmdToClipboard(cmd)
  let a = 'redi @* | ' . a:cmd . ' | redi END'
  execute a
endfunction

command! -nargs=0 RemoveTrailingSpace :let _s=@/ | :%s/\s\+$//e | :let @/=_s | :unlet _s

" open scratch buffer
command! -bar -nargs=? Scratch <args>new | setlocal buftype=nofile bufhidden=hide noswapfile

function! ToggleIndent()
  if &shiftwidth == 2
    setlocal shiftwidth=4 tabstop=4
    echo "Indent = 4"
  else
    setlocal shiftwidth=2 tabstop=2
    echo "Indent = 2"
  endif
endfunction

" repeat last change at a column index
function! DotAtColumnIndex(cidx)
  let a = a:cidx - 1
  execute "normal " . a . "l."
endfunction

" automate opening quickfix window when text adds to it
autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(8, 1)

" make *.bashrc bash files
au BufNewFile,BufRead *.bashrc* set ft=sh

" gui/not gui specific options
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ 12
  " simple gvim
  set guioptions-=m "remove menu bar
  set guioptions-=T "remove toolbar
  set guioptions-=r "remove right-hand scroll bar
  set guioptions-=L "remove left-hand scroll bar
  " shift insert
  imap <silent> <S-Insert> <C-R>*
  nmap <silent> <S-Insert> "*p
endif

" windows options
if has('win32') && filereadable($HOME.'\.vim\windows.vim')
  source ~/.vim/windows.vim
endif

" window tiles with golden ratio, rotate windows
function DoTile() abort
  if (winnr('$') != 1)
    let cur_buflist = tabpagebuflist()
    let cur_layout = map(range(1, winnr('$')), 'win_screenpos(v:val)')
    wincmd H
    windo wincmd J
    1 wincmd w
    wincmd H
    exe 'vertical resize '. string(&columns * 0.618)
    let new_buflist = tabpagebuflist()
    let new_layout = map(range(1, winnr('$')), 'win_screenpos(v:val)')
    " rotate windows
    if  (cur_buflist == new_buflist) && (cur_layout == new_layout)
      wincmd L
      1 wincmd w
      call DoTile()
    endif
  endif
endfunction
