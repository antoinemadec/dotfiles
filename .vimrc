"--------------------------------------------------------------
" plugins
"--------------------------------------------------------------
call plug#begin('~/.vim/plugins_by_vimplug')
Plug 'morhetz/gruvbox'                                                              " colorscheme
if v:version >= 704
  Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'                   " file navigator
endif
Plug 'itchyny/lightline.vim'                                                        " status line
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-completion' }   " fuzzy search in a dir
Plug 'junegunn/fzf.vim'                                                             " fuzzy search in a dir/buffers/files etc
Plug 'junegunn/vim-easy-align'                                                      " easy alignement of line fields
Plug 'vhda/verilog_systemverilog.vim'                                               " Vim Syntax Plugin for Verilog and SystemVerilog
Plug 'vim-scripts/vcscommand.vim'                                                   " diff local CVS SVN and GIT files with current version on the server
Plug 'tpope/vim-fugitive'                                                           " Git wrapper
Plug 'PotatoesMaster/i3-vim-syntax'                                                 " i3/config highlighting
Plug 'valloric/youcompleteme'                                                       " fast, as-you-type, fuzzy-search code completion engine for Vim
call plug#end()

if empty(glob("~/.vim/plugins_by_vimplug"))
  PlugInstall
endif
"--------------------------------------------------------------

"--------------------------------------------------------------
" vim options
"--------------------------------------------------------------
if has('nvim')
  " TODO wait for NVIM support of clipboard=autoselect
  " in order to make mouse=a copy/paste work
  set clipboard+=unnamed
  "vmap <LeftRelease> "*ygv     " does not work with mouse=n or mouse=a
end
set nobackup                    " don't keep a backup file
set backspace=2                 " allow backspacing over everything in insert mode
set textwidth=0                 " don't wrap words by default
set wildmode=longest,list,full  " wildchar completion mode
set wildmenu                    " command-line completion in an enhanced mode
set nocompatible                " get rid of vi compatibility
set hlsearch                    " hilght search
set incsearch                   " while typing a search command, show where the pattern
set expandtab                   " tab expand to space
set tabstop=4                   " number of spaces that a <Tab> in the file counts for
set shiftwidth=2                " Number of spaces to use for each step of (auto)indent.  Used for 'cindent', >>, <<, etc
if exists("&relativenumber")
  set relativenumber            " Show the line number relative to the line with the cursor
  set numberwidth=2             " number of columns to use for the line number
endif
set mouse=a                     " use mouse in all mode. Allow to resize and copy/paste without selecting text outside of the window.
set ttyfast                     " improves smoothness of redrawing when there are multiple windows
set tags=tags;                  " tries to locate the 'tags' file, it first looks at the current directory, then the parent directory, etc
set title                       " change terminal title
set ttimeoutlen=50              " time (ms) waited for a key code or mapped key sequence to complete. Allow faster insert to normal mode
set complete=.,w,b,u,i          " specifies how keyword completion works when CTRL-P or CTRL-N are used
set showcmd                     " in Visual mode the size of the selected area is shown
set viminfo='100,f1,<50,s10     " save 100 lines of marks, 50 lines of registers, max size of item 10kB, hlsearch active when loading file
set ignorecase smartcase        " pattern with at least one uppercase character: search becomes case sensitive
filetype plugin on              " enable loading the plugin files for specific file types
filetype plugin indent on       " enables filetype-specific indent scripts
runtime! ftplugin/man.vim       " allow man to be displayed in vim
"--------------------------------------------------------------

"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
" save file as sudo when vim has not been run with sudo
cmap w!! w !sudo tee > /dev/null %
" open man page in vim
nnoremap K :Man <cword> <CR>
" always use tjump instead of tag, query the user when multiple files match a tag
nnoremap <C-]> g<C-]>
" start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap <F2> :NERDTreeToggle<CR>
" get rid of trailing spaces
nnoremap <silent> <F3> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
" run debugger
nmap <F4> :call ToggleDebugger()<CR>
" text highlighting
nmap <F5> :call HighlightGroup("OwnSearch0", 0)<CR>
nmap <F6> :call HighlightGroup("OwnSearch1", 0)<CR>
nmap <S-F5> :call ClearGroup("OwnSearch0", 0)<CR>
nmap <S-F6> :call ClearGroup("OwnSearch1", 0)<CR>
nmap <C-F5> :call HighlightGroup("OwnSearch0", 1)<CR>
nmap <C-F6> :call HighlightGroup("OwnSearch1", 1)<CR>
nmap <C-S-F5> :call ClearGroup("OwnSearch0", 1)<CR>
nmap <C-S-F6> :call ClearGroup("OwnSearch1", 1)<CR>
" autoinstantiate selected IO definition
vmap <F8> :call VerilogInstance()<CR>
" press F12 before copying text pasted outside of vim to avoid auto indentation
set pastetoggle=<F12>
" buffer explorer style mapping for fzf.vim
nnoremap <script> <silent> <unique> <Leader>be :Buffers<CR>
"--------------------------------------------------------------

"--------------------------------------------------------------
" appearence
"--------------------------------------------------------------
set t_Co=256                " vim uses more colors
set background=dark
colorscheme gruvbox

" lightline
set laststatus=2

let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'relativepath', 'modified' ],
  \             [ 'fugitive'] ],
  \   'right': [ [ 'syntastic', 'lineinfo' ],
  \                          [ 'percent' ],
  \                          [ 'detecttrailingspace', 'filetype' ] ]
  \ },
  \ 'inactive' : {
  \   'left': [ [ 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ] ]
  \ },
  \ 'component_function': {
  \   'fugitive': 'LightlineFugitive',
  \   'detecttrailingspace': 'DetectTrailingSpace'
  \ },
  \ }

autocmd BufEnter,BufWinEnter,InsertLeave * call UpdateGitStatus()
function! UpdateGitStatus()
  let b:GitStatus = ''
  if exists('*fugitive#head')
    let branch = fugitive#head()
    if branch != ''
      let l:gitcmd = 'git -c color.status=false status -s ' . @%
      let b:GitStatus = system(l:gitcmd)
    endif
  endif
endfunction

" copied from NERDTree
let g:NERDTreeIndicatorMap = {
      \ 'Modified'  : '✹',
      \ 'Staged'    : '✚',
      \ 'Untracked' : '✭',
      \ 'Renamed'   : '➜',
      \ 'Unmerged'  : '═',
      \ 'Deleted'   : '✖',
      \ 'Dirty'     : '✗',
      \ 'Clean'     : '✔︎',
      \ 'Ignored'   : '☒',
      \ 'Unknown'   : '?'
      \ }
function! LightlineFugitive()
  let b:lightline_fugitive = ''
  if exists('*fugitive#head')
    let branch = fugitive#head()
    if branch != ''
      let l:statusKey = GetFileGitStatusKey(b:GitStatus[0], b:GitStatus[1])
      let l:indicator = get(g:NERDTreeIndicatorMap, l:statusKey, '')
      let b:lightline_fugitive = branch . ' ' . l:indicator
    endif
  endif
  return b:lightline_fugitive
endfunction
function! GetFileGitStatusKey(us, them)
    if a:us ==# '?' && a:them ==# '?'
        return 'Untracked'
    elseif a:us ==# ' ' && a:them ==# 'M'
        return 'Modified'
    elseif a:us =~# '[MAC]'
        return 'Staged'
    elseif a:us ==# 'R'
        return 'Renamed'
    elseif a:us ==# 'U' || a:them ==# 'U' || a:us ==# 'A' && a:them ==# 'A' || a:us ==# 'D' && a:them ==# 'D'
        return 'Unmerged'
    elseif a:them ==# 'D'
        return 'Deleted'
    elseif a:us ==# '!'
        return 'Ignored'
    else
        return 'Clean'
    endif
endfunction

function! DetectTrailingSpace()
  if mode() == 'n'
    let save_cursor = getpos('.')
    call cursor(1,1)
    let search_result = search("  *$", "c")
    call setpos('.', save_cursor)
    return search_result ? "trailing_space" : ""
  else
    return ""
  endif
endfunction

let NERDTreeShowHidden=1    " show hidden files in NERDTree by default
"--------------------------------------------------------------

"--------------------------------------------------------------
" highlighting
"--------------------------------------------------------------
" highlight non breakable space
set list
set listchars=nbsp:?

" redifine Todo highlight group for more readability
highlight Todo term=standout cterm=bold ctermfg=235 ctermbg=167 gui=bold guifg=#282828 guibg=#fb4934

" highlight extra whitespace
highlight link CustomHighlight_TrailingSpace Todo
match CustomHighlight_TrailingSpace /\s\+$/
autocmd BufWinEnter * match CustomHighlight_TrailingSpace /\s\+$/
autocmd InsertEnter * match CustomHighlight_TrailingSpace /\s\+\%#\@<!$/
autocmd InsertLeave * match CustomHighlight_TrailingSpace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" always highlight TODO and FIXME no matter the filetype
highlight link CustomHighlight_Warning Todo
augroup HiglightTODO
  autocmd!
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomHighlight_Warning', 'TODO\|FIXME', -1)
augroup END

" hightlight 2 different groups with different colors for readability,
" F5: pink group; F6: blue group
highlight OwnSearch0  term=bold,undercurl,reverse cterm=bold,reverse ctermfg=magenta gui=bold,reverse guifg=magenta
highlight OwnSearch1 term=bold,reverse cterm=bold,reverse gui=bold,reverse ctermfg=6
function! HighlightGroup(gr, w)
  let a = "syntax match " . a:gr . " '\\\<" . expand ("<cword>") . "\\\>' containedin=ALL"
  let cur_win = winnr()
  if a:w == 0
    execute a
  else
    windo execute a
  endif
  exe cur_win . "wincmd w"
endfunction
function! ClearGroup(gr, w)
  let a = "syntax clear " . a:gr
  let cur_win = winnr()
  if a:w == 0
    execute a
  else
    windo execute a
  endif
  exe cur_win . "wincmd w"
endfunction
"--------------------------------------------------------------

"--------------------------------------------------------------
" folding
"--------------------------------------------------------------
set foldmethod=indent
set foldnestmax=8
set nofoldenable
nmap zi :call ToggleFoldEnable()<CR>
function! ToggleFoldEnable()
  let cur_foldlevel = &foldlevel
  set foldenable!
  if &foldenable
    execute "normal zR"
    let &foldcolumn = &foldlevel + 1
    let &foldlevel = cur_foldlevel
  else
    set foldcolumn=0
  endif
endfunction
"--------------------------------------------------------------

"--------------------------------------------------------------
" completion
"--------------------------------------------------------------
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
nnoremap <leader>g :YcmCompleter GoTo<CR>
nnoremap <leader>pd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>pc :YcmCompleter GoToDeclaration<CR>
"--------------------------------------------------------------

"--------------------------------------------------------------
" verilog
"--------------------------------------------------------------
" instatiation from ports
function! VerilogInstance() range
  let cmd=a:firstline . "," . a:lastline . "!" . "~/.vim/scripts/verilog_instance.pl"
  execute cmd
endfunction
"--------------------------------------------------------------

"--------------------------------------------------------------
" cpp
"--------------------------------------------------------------
" override default indent based on plugin
autocmd FileType c,cpp setlocal shiftwidth=4

" Command Make will call make and then cwindow which
" opens a 3 line error window if any errors are found.
" If no errors, it closes any open cwindow.
command -nargs=* Make make <args> | cwindow 3

" setup gdb front end
let g:pyclewn_terminal = "xterm, -e"
let g:pyclewn_python   = "python3"
let g:pyclewn_args     = "-d --gdb=async --window=right"

function! ToggleDebugger()
  if has("netbeans_enabled")
    Cunmapkeys
    Cexitclewn
  else
    call inputsave()
    let cmdline = input("Turn on debugger, overrides some remaps (to undo :Cunmapkeys)\n
          \Gdb commands can be run in vim with :C<gdb_cmd>\n
          \Running 'gdb --args <cmdline>', please enter <cmdline>: ", '', 'file')
    call inputrestore()
    let run_pyclewn = 'Pyclewn gdb'
    if cmdline != ""
      let run_pyclewn = run_pyclewn . ' --args ' . cmdline
    endif
    execute run_pyclewn
    Cmapkeys
    Cinferiortty
  endif
endfunction
"--------------------------------------------------------------

"--------------------------------------------------------------
" misc
"--------------------------------------------------------------
" abreviations
abbr sigm_print `SIGM_PRINT(`SIGM_NOTICE, ("\n"));<Left><Left><Left><Left><Left><Left>

" redirection of vim commands in clipboard
command! -nargs=1 RediCmdToClipboard call RediCmdToClipboard(<f-args>)
function! RediCmdToClipboard(cmd)
  let a = 'redi @* | ' . a:cmd . ' | redi END'
  execute a
endfunction

" set ft=sh for *.bashrc files
au BufNewFile,BufRead *.bashrc* call SetFileTypeSH("bash")

" simple gvim
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
"--------------------------------------------------------------
