" environement variables used:
"   TERM_ITALICS          : enable italic capabilites if 'true'
"   TERM_COLORS           : enable termguicolors if >= 256
"   TERM_FANCY_CURSOR     : enable thin insert cursor if 'true'
"   TERM_BRACKETED_PASTE  : disable bracketed paste if not 'true'
"   CSCOPE_DB             : cscope database

"--------------------------------------------------------------
" plugins
"--------------------------------------------------------------
let g:polyglot_disabled = ['v', 'python-compiler']
call plug#begin('~/.vim/plugins')
" style
Plug 'gruvbox-community/gruvbox'                                           " colorscheme
Plug 'itchyny/lightline.vim'                                               " status line
Plug 'yggdroot/indentline'                                                 " display thin vertical lines at each indentation level
Plug 'antoinemadec/vim-indentcolor-filetype'                               " make notes more readable
Plug 'mhinz/vim-startify'                                                  " start screen for vim
Plug 'ryanoasis/vim-devicons'                                              " add icons to your plugins
" completion
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}         " completion, snippets etc
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}             " fuzzy search in a dir
Plug 'junegunn/fzf.vim'                                                    " fuzzy search in a dir
Plug 'antoinemadec/coc-fzf'
" languages
Plug 'sheerun/vim-polyglot'                                                " a collection of language packs for vim
Plug 'antoinemadec/vim-verilog-instance', {'for': 'verilog_systemverilog'} " verilog port instantiation from port declaration
Plug 'vhda/verilog_systemverilog.vim', {'for': 'verilog_systemverilog'}    " vim syntax plugin for verilog and systemverilog
" misc
Plug 'andymass/vim-matchup'                                                " replacement for the vim plugin matchit.vim
Plug 'antoinemadec/vim-highlight-groups'                                   " add words in highlight groups on the fly
Plug 'RRethy/vim-illuminate'                                               " highlight other uses of the current word under the cursor
Plug 'chamindra/marvim'                                                    " store/load macros easily
Plug 'honza/vim-snippets'                                                  " snippets working with coc.nvim
Plug 'junegunn/vim-easy-align'                                             " easy alignment of line fields
Plug 'kana/vim-textobj-indent'                                             " add indent text object for motion like 'dii'
Plug 'kana/vim-textobj-line'                                               " add line text object for motion like 'dil'
Plug 'kana/vim-textobj-user'                                               " needed to add text object
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}                           " display buffer's classes/functions/vars based on ctags
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}                       " file explorer
Plug 'skywind3000/asyncrun.vim'                                            " run asynchronous bash commands
Plug 'mg979/vim-visual-multi'                                              " multiple cursors
Plug 'tpope/vim-commentary'                                                " comment stuff out
Plug 'tpope/vim-fugitive'                                                  " git wrapper
Plug 'tpope/vim-repeat'                                                    " remaps '.' in a way that plugins can tap into it
Plug 'tpope/vim-sensible'                                                  " vim defaults that everyone can agree on
Plug 'tpope/vim-speeddating'                                               " use ctrl-a/ctrl-x to increment dates, times, and more
Plug 'tpope/vim-surround'                                                  " delete, change and add surroundings in pairs
Plug 'tpope/vim-abolish'                                                    " work with variations of a word
Plug 'antoinemadec/FixCursorHold.nvim'                                     " fix CursorHold perf bug
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
set noshowcmd                  " don't show (partial) command in the last line of the screen
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
    highlight link CustomHighlight_TrailingSpace Todo
  endif
  exe l:nr . "wincmd w"
  call lightline#update()
endfunction
call ToggleTrailingSpace()

autocmd BufWinEnter * call MatchPattern('trailingspace',
      \ 'CustomHighlight_TrailingSpace',  '\s\+$', 11)
autocmd InsertEnter * call MatchPattern('trailingspace',
      \ 'CustomHighlight_TrailingSpace', '\s\+\%#\@<!$', 11)
autocmd InsertLeave * call MatchPattern('trailingspace',
      \ 'CustomHighlight_TrailingSpace',  '\s\+$', 11)

" highlight non breakable space
set listchars=nbsp:?

" always highlight TBD TODO and FIXME no matter the filetype
highlight link CustomHighlight_Warning Todo
autocmd WinEnter,VimEnter * call MatchPattern('todo',
      \ 'CustomHighlight_Warning', 'TBD\|TODO\|FIXME', 11)

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

function MatchPattern(id_str, hl, pattern, priority) abort
  exe 'let id_varname = "match_' . a:id_str . '_id"'
  let id_value = get(w:, id_varname, -1)
  if id_value != -1
    call matchdelete(id_value)
  endif
  let matchadd_id = matchadd(a:hl, a:pattern, a:priority, id_value)
  exe 'let w:' . id_varname . ' = matchadd_id'
endfunction

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

command! ToggleIndent call ToggleIndent()
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
function WindowDoTile() abort
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
      call WindowDoTile()
    endif
  endif
endfunction

" make current window float or create float with empty buffer
function WindowDoFloat(...) abort
  let create       = a:0 >= 1 ? a:1 : 0
  let width_ratio  = a:0 >= 2 ? a:2 : 0.9
  let height_ratio = a:0 >= 3 ? a:3 : 0.6
  let width = float2nr(&columns * width_ratio)
  let height = float2nr(&lines * height_ratio)
  let config = { 'relative': 'editor',
        \ 'row': (&lines - height) / 2,
        \ 'col': (&columns - width) / 2,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \}
  if create
    let buf = nvim_create_buf(v:false, v:false)
    call nvim_open_win(buf, v:true, config)
  else
    call nvim_win_set_config(0, config)
  endif
endfunction

" help
function! OpenHelpInCurrentWindow(topic)
  view $VIMRUNTIME/doc/help.txt
  setl filetype=help
  setl buftype=help
  setl nomodifiable
  setl nobuflisted
  exe 'keepjumps help ' . a:topic
endfunction
command -complete=help -nargs=* H call WindowDoFloat(1, 0.6) | call OpenHelpInCurrentWindow(<q-args>)
command -complete=help -nargs=* Ht tab help <args>
