" environement variables used:
"   TERM_ITALICS          : enable italic capabilites if 'true'
"   TERM_COLORS           : enable termguicolors if >= 256
"   TERM_FANCY_CURSOR     : enable thin insert cursor if 'true'
"   TERM_BRACKETED_PASTE  : disable bracketed paste if not 'true'
"   CSCOPE_DB             : cscope database, compile_commands.json
"   LIBCLANG_PATH         : overrides g:deoplete#sources#clang#libclang_path
"   CLANG_HEADER          : overrides g:deoplete#sources#clang#clang_header

"--------------------------------------------------------------
" plugins
"--------------------------------------------------------------
call plug#begin('~/.vim/plugins_by_vimplug')
Plug 'gruvbox-community/gruvbox'                                  " colorscheme
Plug 'itchyny/lightline.vim'                                      " status line
Plug 'junegunn/fzf',
      \ {'dir': '~/.fzf','do': './install --all --no-completion'} " fuzzy search in a dir
Plug 'junegunn/fzf.vim'                                           " fuzzy search in a dir
Plug 'junegunn/vim-easy-align'                                    " easy alignment of line fields
Plug 'antoinemadec/vim-highlight-groups'                          " add words in highlight groups on the fly
Plug 'vim-scripts/vcscommand.vim'                                 " diff CVS SVN and GIT files with remote version
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
Plug 'Yggdroot/indentLine'                                        " display thin vertical lines at each indentation level
Plug 'andymass/vim-matchup'                                       " replacement for the vim plugin matchit.vim
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}              " file explorer
Plug 'neomake/neomake'                                            " asyncronous Syntastic
Plug 'sinetoami/lightline-neomake'                                " neomake info for lightline
if v:version >= 800
  Plug 'Shougo/deoplete.nvim'                                     " extensible and asynchronous completion for neovim/Vim8
  Plug 'Shougo/neoinclude.vim'                                    " completion: includes, headers etc
endif
if !has('nvim')
  Plug 'roxma/nvim-yarp'                                          " needed by deoplete
  Plug 'roxma/vim-hug-neovim-rpc'                                 " needed by deoplete
endif
" filetype specific
Plug 'artur-shaik/vim-javacomplete2', { 'for' : 'java' }          " add omnifunc used by deoplete; requires 'apt install default-jdk'
Plug 'xolox/vim-misc', { 'for' : 'lua' }                          " needed by vim-lua-ftplugin
Plug 'xolox/vim-lua-ftplugin', { 'for' : 'lua' }                  " add omnifunc used by deoplete
Plug 'vim-scripts/luarefvim', { 'for' : 'lua' }                   " lua reference doc: use K to open
Plug 'davidhalter/jedi-vim', {'for': 'python'}                    " jedi completion (python)
Plug 'zchee/deoplete-jedi', {'for': 'python'}                     " deoplete: add python support
Plug 'zchee/deoplete-clang', {'for': 'cpp'}                       " deoplete: add c++ support
Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}           " PEP8 compatible multi line indentation
Plug 'vhda/verilog_systemverilog.vim',
      \ {'for': 'verilog_systemverilog'}                          " Vim Syntax Plugin for Verilog and SystemVerilog
Plug 'antoinemadec/vim-verilog-instance',
      \ {'for': 'verilog_systemverilog'}                          " Verilog port instantiation from port declaration
Plug 'PotatoesMaster/i3-vim-syntax', {'for': 'i3'}                " i3/config highlighting
Plug 'kshenoy/TWiki-Syntax'                                       " Twiki highlighting
Plug 'antoinemadec/vim-indentcolor-filetype'                      " make notes more readable
Plug 'chrisbra/csv.vim'                                           " a filetype plugin for csv files
call plug#end()

if empty(glob("~/.vim/plugins_by_vimplug"))
  PlugInstall
endif

"--------------------------------------------------------------
" vim options
"--------------------------------------------------------------
set nocompatible               " get rid of vi compatibility
set nobackup                   " don't keep a backup file
set textwidth=0                " don't wrap words by default
set wildmode=longest,list,full " wildchar completion mode
set hlsearch                   " highlight search
set expandtab                  " tab expand to space
set tabstop=2                  " number of spaces that a <Tab> in the file counts for
set shiftwidth=2               " number of spaces to use for each step of (auto)indent
set lazyredraw                 " no screen redrawing while executing macros, registers etc
set isfname-=,                 " don't try to match certain characters in filename
set isfname-==                 " don't try to match certain characters in filename
" highlight current line
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
if exists("&relativenumber")
  set number relativenumber    " show the line number relative to the line with the cursor
endif
set mouse=a                    " allow to resize and copy/paste without selecting text outside of the window
set title                      " change terminal title
set ttimeoutlen=50             " ms waited for a key code/sequence to complete. Allow faster insert to normal mode
set complete=.,w,b,u           " specifies how keyword completion works when CTRL-P or CTRL-N are used
set showcmd                    " in Visual mode the size of the selected area is shown
set ignorecase smartcase       " pattern with at least one uppercase character: search becomes case sensitive
set cscopetag                  " cstag performs the equivalent of tjump when searching through tags file
set cscopetagorder=1           " tag files searched before cscopte database
set cscoperelative             " basename of cscope.out is be used as the prefix
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
let g:ft_man_no_sect_fallback = 1
runtime! ftplugin/man.vim      " allow man to be displayed in vim

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

source ~/.vim/my_lightline.vim

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
" completion
"--------------------------------------------------------------
" multiple cursors compatibility
func! Multiple_cursors_before()
  if deoplete#is_enabled()
    call deoplete#disable()
    let g:deoplete_is_enable_before_multi_cursors = 1
  else
    let g:deoplete_is_enable_before_multi_cursors = 0
  endif
endfunc
func! Multiple_cursors_after()
  if g:deoplete_is_enable_before_multi_cursors
    call deoplete#enable()
  endif
endfunc

" close preview window
au CompleteDone * pclose

" systemverilog
if v:version >= 800
  call deoplete#custom#var('omni', 'functions', {
        \ 'verilog_systemverilog': 'verilog_systemverilog#Complete',
        \ })
  call deoplete#custom#var('omni', 'input_patterns', {
        \ 'verilog_systemverilog': '\w+[.:]+\w*',
        \ })
endif

" python
let g:deoplete#sources#jedi#python_path = 'python3'
let g:deoplete#sources#jedi#show_docstring = 1
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0

" lua
let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
let g:lua_define_completion_mappings = 0
if v:version >= 800
  call deoplete#custom#var('omni', 'functions', {
        \ 'lua': 'xolox#lua#omnifunc',
        \ })
  call deoplete#custom#var('omni', 'input_patterns', {
        \ 'lua': '\w+|\w+[.:]\w*',
        \ })
endif

" c++
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-7/lib/libclang.so.1'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-7/lib/clang'
if $LIBCLANG_PATH != ""
  let g:deoplete#sources#clang#libclang_path = $LIBCLANG_PATH
endif
if $CLANG_HEADER != ""
  let g:deoplete#sources#clang#clang_header = $CLANG_HEADER
endif
if filereadable( $CSCOPE_DB . "/compile_commands.json")
  let g:deoplete#sources#clang#clang_complete_database = $CSCOPE_DB
endif

command! ToggleCompletion call ToggleCompletion()
function ToggleCompletion()
  if deoplete#is_enabled()
    call deoplete#disable()
    echom "Deoplete disabled"
  else
    nnoremap <leader>g :call jedi#goto()<CR>
    " use TAB to complete
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ deoplete#manual_complete()
    function! s:check_back_space() abort "{{{
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction"}}}
    call deoplete#enable()
    echom "Deoplete enabled"
  endif
endfunction

function! DisplayDoc()
  let l:cword = expand('<cword>')
  if &filetype == "python"
    let l:pydoc_stdout = system("pydoc3 " . l:cword)
    if l:pydoc_stdout[1:32] != "o Python documentation found for"
      Scratch | 0 put =l:pydoc_stdout | normal gg
      set ft=man
    endif
  elseif &filetype == "c" || &filetype == "cpp"
    if execute("Man 3 " . l:cword) =~ 'Cannot find a '
      let l:man_output = execute("Man 3 std::" . l:cword)
    endif
    redraw
    echom "https://en.cppreference.com/mwiki/index.php?title=Special%3ASearch&search="
          \ . l:cword
  else
    execute "Man " . l:cword
  endif
endfunction

"--------------------------------------------------------------
" verilog
"--------------------------------------------------------------
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

" set commentstring, map '-' to 'begin end' surrounding
autocmd FileType verilog_systemverilog let b:surround_45 = "begin \r end"
autocmd FileType verilog_systemverilog setlocal commentstring=//%s

" verilog_systemverilog
nnoremap <leader>i :VerilogFollowInstance<CR>
nnoremap <leader>I :VerilogFollowPort<CR>
let g:verilog_disable_indent_lst = "eos"

let g:verilog_instance_skip_last_coma = 1

"--------------------------------------------------------------
" cpp
"--------------------------------------------------------------
autocmd FileType c,cpp setlocal shiftwidth=4 tabstop=4
autocmd FileType c,cpp setlocal completeopt-=preview " no preview for deoplete
if filereadable("cscope.out")
  cs add cscope.out
elseif $CSCOPE_DB != ""
  cs add $CSCOPE_DB
endif

"--------------------------------------------------------------
" java
"--------------------------------------------------------------
autocmd FileType java setlocal shiftwidth=4 tabstop=4
autocmd FileType java nnoremap <buffer> <leader>r :RunJavaCurrentBuffer<CR>

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
  let cur_buf_name = expand('%')
  if isdirectory(cur_buf_name)
    return cur_buf_name
  elseif cur_buf_name == "" || &buftype ==# 'terminal'
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

" AsyncRun
command! -nargs=* -complete=shellcmd Run AsyncRun <args>
command! -nargs=0 RunCurrentBuffer :w | execute("Run " . expand('%:p'))
command! -nargs=0 RunAndTimeCurrentBuffer :w | execute("Run time(" . expand('%:p') . ")")
command! -nargs=0 RunJavaCurrentBuffer :w | execute("Run javac " . expand('%:t') .
      \ " && java " . expand('%:r') )
command! -bang -nargs=* -complete=file Grep AsyncRun -program=grep @ <args>
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

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

" csv filetype
aug CSV_Editing
  au!
  au BufRead,BufWritePost *.csv :%ArrangeColumn
  au BufWritePre *.csv :%UnArrangeColumn
aug end

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

" macros
let g:marvim_store = $HOME."/.vim/marvim"
let g:marvim_find_key = ''
let g:marvim_store_key = ''
let g:macro_debug_cnt = 0
command! MacroStore call marvim#macro_store()
command! MacroLoad call marvim#search()

" tagbar
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_ctags_bin = 'uctags'

"startify
let g:startify_custom_header = [
      \ ' __      ___',
      \ ' \ \    / (_)',
      \ '  \ \  / / _ _ __ ___',
      \ '   \ \/ / | |  _ ` _ \',
      \ '    \  /  | | | | | | |',
      \ '     \/   |_|_| |_| |_|',
      \]
let g:startify_commands = [':Scratch']
let g:startify_lists = [
      \ { 'type': 'commands',  'indices': ['s'] },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ ]
let g:startify_change_to_dir = 0

let g:matchup_matchparen_status_offscreen = 0

" indent line
let g:indentLine_fileTypeExclude = ['text', 'startify', 'defx']
let g:indentLine_bufTypeExclude = ['help', 'terminal', 'popup', 'quickfix']

" nerdtree
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinPos = "right"
let g:NERDTreeHijackNetrw = 0

" neomake
call neomake#configure#automake('nr')
