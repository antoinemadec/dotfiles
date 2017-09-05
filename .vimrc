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
Plug 'antoinemadec/vim-verilog-instance'                                            " TODO
Plug 'vim-scripts/vcscommand.vim'                                                   " diff local CVS SVN and GIT files with current version on the server
Plug 'tpope/vim-fugitive'                                                           " Git wrapper
Plug 'tpope/vim-surround'                                                           " provides mappings to easily delete, change and add such surroundings in pairs
Plug 'tpope/vim-commentary'                                                         " comment stuff out
Plug 'tpope/vim-sensible'                                                           " vim defaults that (hopefully) everyone can agree on
Plug 'PotatoesMaster/i3-vim-syntax'                                                 " i3/config highlighting
if (v:version >= 704 && has('patch1578')) || has('nvim')
  Plug 'valloric/youcompleteme'                                                     " fast, as-you-type, fuzzy-search code completion engine for Vim
endif
" just for fun:
Plug 'itchyny/screensaver.vim'                                                      " vim screensavers
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
  set guicursor=                " fancy guiscursor feature are not working with Terminator
end
set nocompatible                " get rid of vi compatibility
set nobackup                    " don't keep a backup file
set textwidth=0                 " don't wrap words by default
set wildmode=longest,list,full  " wildchar completion mode
set hlsearch                    " hilght search
set expandtab                   " tab expand to space
set tabstop=4                   " number of spaces that a <Tab> in the file counts for
set shiftwidth=2                " Number of spaces to use for each step of (auto)indent.  Used for 'cindent', >>, <<, etc
set lazyredraw                  " screen will not be redrawn while executing macros, registers and other commands that have not been typed
if exists("&relativenumber")
  set relativenumber            " Show the line number relative to the line with the cursor
  set numberwidth=2             " number of columns to use for the line number
endif
set mouse=a                     " use mouse in all mode. Allow to resize and copy/paste without selecting text outside of the window.
set ttyfast                     " improves smoothness of redrawing when there are multiple windows
set title                       " change terminal title
set ttimeoutlen=50              " time (ms) waited for a key code or mapped key sequence to complete. Allow faster insert to normal mode
set complete=.,w,b,u            " specifies how keyword completion works when CTRL-P or CTRL-N are used
set showcmd                     " in Visual mode the size of the selected area is shown
set ignorecase smartcase        " pattern with at least one uppercase character: search becomes case sensitive
runtime! ftplugin/man.vim       " allow man to be displayed in vim
runtime! macros/matchit.vim     " allow usage of % to match 'begin end' and other '{ }' kind of pairs
"-------------------------------------------------------------

"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
" terminal mode mappings
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif
" ALT+{h,j,k,l} to navigate windows from any mode:
if has('nvim')
  tnoremap <A-h> <C-\><C-N><C-w>h
  tnoremap <A-j> <C-\><C-N><C-w>j
  tnoremap <A-k> <C-\><C-N><C-w>k
  tnoremap <A-l> <C-\><C-N><C-w>l
endif
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" add '.' support in visual mode
vnoremap . :<C-w>let cidx = col(".")<CR> :'<,'>call DotAtColumnIndex(cidx)<CR>
" save file as sudo when vim has not been run with sudo
cmap w!! w !sudo tee > /dev/null %
" open man page in vim
nnoremap K :call DisplayDoc() <CR>
" always use tjump instead of tag, query the user when multiple files match a tag
nnoremap <C-]> g<C-]>
" start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap <F2> :NERDTreeToggle<CR>
" get rid of trailing spaces
nnoremap <silent> <F3> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
nnoremap <F4> :ScreenSaver largeclock<CR>
" text highlighting
nmap <F5> :call HighlightGroup("OwnSearch0", 0)<CR>
nmap <F6> :call HighlightGroup("OwnSearch1", 0)<CR>
nmap <S-F5> :call ClearGroup("OwnSearch0", 0)<CR>
nmap <S-F6> :call ClearGroup("OwnSearch1", 0)<CR>
nmap <C-F5> :call HighlightGroup("OwnSearch0", 1)<CR>
nmap <C-F6> :call HighlightGroup("OwnSearch1", 1)<CR>
nmap <C-S-F5> :call ClearGroup("OwnSearch0", 1)<CR>
nmap <C-S-F6> :call ClearGroup("OwnSearch1", 1)<CR>
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
source ~/.vim/my_lightline.vim

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

"--------------------------------------------------------------
" completion
"--------------------------------------------------------------
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_python_binary_path = 'python'
nnoremap <leader>g :YcmCompleter GoTo<CR>
nnoremap <leader>pd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>pc :YcmCompleter GoToDeclaration<CR>

function! DisplayDoc()
  if &filetype == "python"
    YcmCompleter GetDoc
  else
    execute "Man " . expand('<cword>')
  endif
endfunction
"--------------------------------------------------------------

" "--------------------------------------------------------------
" " verilog
" "--------------------------------------------------------------
" map '-' to 'begin end' surrounding
autocmd FileType verilog_systemverilog let b:surround_45 = "begin \r end"

" verilog_systemverilog mappings
nnoremap <leader>i :VerilogFollowInstance<CR>
nnoremap <leader>I :VerilogFollowPort<CR>

" commentary
autocmd FileType verilog_systemverilog setlocal commentstring=//%s
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

" repeat last change at a column index
function! DotAtColumnIndex(cidx)
  let a = a:cidx - 1
  execute "normal " . a . "l."
endfunction

" add command to open terminals
if has('nvim')
  command! -nargs=* T split | terminal <args>
  command! -nargs=* VT vsplit | terminal <args>
endif

" screensaver requires password
let g:screensaver_password = 1
call screensaver#source#password#set('fbbf2ec210fa1e6eb7d7f7e1bc34a4a8f93798b546fb5047be7ab21be75c61cc')
"--------------------------------------------------------------
