"--------------------------------------------------------------
" plugins
"--------------------------------------------------------------
call plug#begin('~/.vim/plugins_by_vimplug')
Plug 'morhetz/gruvbox'                                                                      " colorscheme
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'                             " file navigator
Plug 'itchyny/lightline.vim' | Plug 'shinchu/lightline-gruvbox.vim'                         " status line
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim' " fuzzy search in a dir
Plug 'vhda/verilog_systemverilog.vim'                                                       " Vim Syntax Plugin for Verilog and SystemVerilog
Plug 'vcscommand.vim'                                                                       " diff local CVS SVN and GIT files with current version on the server
Plug 'bufexplorer.zip'                                                                      " BufExplorer Plugin for Vim (use \be)
Plug 'PotatoesMaster/i3-vim-syntax' " i3/config highlighting
call plug#end()

if empty(glob("~/.vim/plugins_by_vimplug"))
  PlugInstall
endif
"--------------------------------------------------------------

"--------------------------------------------------------------
" vim options
"--------------------------------------------------------------
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
set relativenumber              " Show the line number relative to the line with the cursor
set numberwidth=2               " number of columns to use for the line number
set mouse=a                     " use mouse in all mode. Allow to resize and copy/paste without selecting text outside of the window.
set ttyfast                     " improves smoothness of redrawing when there are multiple windows
set tags=tags;                  " tries to locate the 'tags' file, it first looks at the current directory, then the parent directory, etc
set title                       " change terminal title
set ttimeoutlen=50              " time (ms) waited for a key code or mapped key sequence to complete. Allow faster insert to normal mode
set complete=.,w,b,u,i          " specifies how keyword completion works when CTRL-P or CTRL-N are used
set showcmd                     " in Visual mode the size of the selected area is shown
set viminfo='100,f1,<50,s10     " save 100 lines of marks, 50 lines of registers, max size of item 10kB, hlsearch active when loading file
filetype plugin on              " enable loading the plugin files for specific file types
filetype plugin indent on       " enables filetype-specific indent scripts
runtime! ftplugin/man.vim       " allow man to be displayed in vim
"--------------------------------------------------------------

"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
" press F12 before copying text pasted outside of vim to avoid auto indentation
set pastetoggle=<F12>
" always use tjump instead of tag, query the user when multiple files match a tag
nnoremap <C-]> g<C-]>
nmap <F2> :NERDTreeToggle<CR>
vmap <F8> :call VerilogInstance()<CR>
nnoremap K :Man <cword> <CR>
" text highlighting
nmap <F5> :call HighlightGroup("OwnSearch0", 0)<CR>
nmap <F6> :call HighlightGroup("OwnSearch1", 0)<CR>
nmap <S-F5> :call ClearGroup("OwnSearch0", 0)<CR>
nmap <S-F6> :call ClearGroup("OwnSearch1", 0)<CR>
nmap <C-F5> :call HighlightGroup("OwnSearch0", 1)<CR>
nmap <C-F6> :call HighlightGroup("OwnSearch1", 1)<CR>
nmap <C-S-F5> :call ClearGroup("OwnSearch0", 1)<CR>
nmap <C-S-F6> :call ClearGroup("OwnSearch1", 1)<CR>
if has('nvim')
  tnoremap <Esc> <C-\><C-n>     " in terminal mode, Esc goes to normal mode
endif
"--------------------------------------------------------------

"--------------------------------------------------------------
" appearence
"--------------------------------------------------------------
" lightline
set laststatus=2
let g:lightline = {
    \ 'colorscheme': 'gruvbox',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'myreadonly', 'relativepath', 'modified' ] ],
    \   'right': [ [ 'syntastic', 'lineinfo' ],
    \                          [ 'percent' ],
    \                          [ 'detecttrailingspace', 'filetype' ] ]
    \ },
    \ 'component_function': {
    \   'detecttrailingspace': 'DetectTrailingSpace'
    \ },
    \ }
" TODO: use expand to highlight trailing spaces in lightline
"    \ 'component_expand': {
"    \   'detecttrailingspace': 'DetectTrailingSpace'
"    \ },
"    \ 'component_type': {
"    \   'detecttrailingspace': 'error'
"    \ },

function! DetectTrailingSpace()
  if mode() == 'n'
    let save_cursor = getcurpos()
    call cursor(1,1)
    let search_result = search("  *$", "c")
    call setpos('.', save_cursor)
    return search_result ? "trailing_space" : ""
  else
    return ""
  endif
endfunction

set t_Co=256                " vim uses more colors
set background=dark
colorscheme gruvbox

let NERDTreeShowHidden=1    " show hidden files in NERDTree by default
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
"--------------------------------------------------------------
