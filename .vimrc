"--------------------------------------------------------------
" plugins
"--------------------------------------------------------------
call plug#begin('~/.vim/plugins_by_vimplug')
Plug 'morhetz/gruvbox'                                                         " colorscheme
if v:version >= 704
  Plug 'scrooloose/nerdtree',         {'on': 'NERDTreeToggle'}                 " file navigator
  Plug 'Xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}
endif
Plug 'itchyny/lightline.vim'                                                   " status line
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all --no-completion'} " fuzzy search in a dir
Plug 'junegunn/fzf.vim'                                                        " fuzzy search in a dir/buffers/files etc
Plug 'junegunn/vim-easy-align'                                                 " easy alignment of line fields
Plug 'vhda/verilog_systemverilog.vim', {'for': 'verilog_systemverilog'}        " Vim Syntax Plugin for Verilog and SystemVerilog
Plug 'antoinemadec/vim-verilog-instance', {'for': 'verilog_systemverilog'}     " Verilog port instantiation from port declaration
Plug 'antoinemadec/vim-highlight-groups'                                       " add words in highlight groups on the fly
Plug 'antoinemadec/vim-conf2_filetype'                                         " copy of conf filetype with // comments instead of #
Plug 'vim-scripts/vcscommand.vim'                                              " diff local CVS SVN and GIT files with server version
Plug 'tpope/vim-fugitive'                                                      " Git wrapper
Plug 'tpope/vim-surround'                                                      " easily delete, change and add such surroundings in pairs
Plug 'tpope/vim-commentary'                                                    " comment stuff out
Plug 'tpope/vim-sensible'                                                      " vim defaults that (hopefully) everyone can agree on
Plug 'tpope/vim-repeat'                                                        " remaps '.' in a way that plygubs can tap into it
Plug 'PotatoesMaster/i3-vim-syntax', {'for': 'i3'}                             " i3/config highlighting
if (v:version >= 704 && has('patch1578')) || has('nvim')
  Plug 'valloric/YouCompleteMe', {'on': []}                                    " fast, as-you-type, code completion engine for Vim
endif
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
  set guicursor=               " fancy guiscursor feature are not working with Terminator
end
set nocompatible               " get rid of vi compatibility
set nobackup                   " don't keep a backup file
set textwidth=0                " don't wrap words by default
set wildmode=longest,list,full " wildchar completion mode
set hlsearch                   " highlight search
set expandtab                  " tab expand to space
set tabstop=2                  " number of spaces that a <Tab> in the file counts for
set shiftwidth=2               " number of spaces to use for each step of (auto)indent
set lazyredraw                 " no screen redrawing while executing macros, registers etc
if exists("&relativenumber")
  set relativenumber           " show the line number relative to the line with the cursor
  set numberwidth=2            " number of columns to use for the line number
endif
set mouse=a                    " allow to resize and copy/paste without selecting text outside of the window
set title                      " change terminal title
set ttimeoutlen=50             " ms waited for a key code/sequence to complete. Allow faster insert to normal mode
set complete=.,w,b,u           " specifies how keyword completion works when CTRL-P or CTRL-N are used
set showcmd                    " in Visual mode the size of the selected area is shown
set ignorecase smartcase       " pattern with at least one uppercase character: search becomes case sensitive
runtime! ftplugin/man.vim      " allow man to be displayed in vim
runtime! macros/matchit.vim    " allow usage of % to match 'begin end' and other '{ }' kind of pairs
"-------------------------------------------------------------

"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  tnoremap <A-Left> <C-\><C-N><C-w>h
  tnoremap <A-Down> <C-\><C-N><C-w>j
  tnoremap <A-Up> <C-\><C-N><C-w>k
  tnoremap <A-Right> <C-\><C-N><C-w>l
endif
inoremap <A-Left>  <C-\><C-N><C-w>h
inoremap <A-Down>  <C-\><C-N><C-w>j
inoremap <A-Up>    <C-\><C-N><C-w>k
inoremap <A-Right> <C-\><C-N><C-w>l
nnoremap <A-Left>  <C-w>h
nnoremap <A-Down>  <C-w>j
nnoremap <A-Up>    <C-w>k
nnoremap <A-Right> <C-w>l
" add '.' support in visual mode
vnoremap . :<C-w>let cidx = col(".")<CR> :'<,'>call DotAtColumnIndex(cidx)<CR>
" save file as sudo
cmap w!! w !sudo tee > /dev/null %
nnoremap K :call DisplayDoc() <CR>
" use tjump instead of tag, query the user when multiple files match a tag
nnoremap <C-]> g<C-]>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap <F2> :NERDTreeToggle<CR>
" get rid of trailing spaces
nnoremap <silent> <F3> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
nnoremap <silent> <F4> :EnableYCM<CR>
nnoremap <silent> <F5> :HighlightGroupsAddWord 4 0<CR>
nnoremap <silent> <F6> :HighlightGroupsAddWord 6 0<CR>
nnoremap <silent> <S-F5> :HighlightGroupsClearGroup 4 0<CR>
nnoremap <silent> <S-F6> :HighlightGroupsClearGroup 6 0<CR>
nnoremap <silent> <C-F5> :HighlightGroupsAddWord 4 1<CR>
nnoremap <silent> <C-F6> :HighlightGroupsAddWord 6 1<CR>
nnoremap <silent> <C-S-F5> :HighlightGroupsClearGroup 4 1<CR>
nnoremap <silent> <C-S-F6> :HighlightGroupsClearGroup 6 1<CR>
nnoremap <silent> <F8> :call ToggleListTrailingSpacesDisplay()<CR>
nnoremap <silent> <F9> :set spell!<CR>
inoremap <silent> <F9> <C-o>:set spell!<CR>
" paste avoiding auto indentation
set pastetoggle=<F12>
nnoremap <script> <silent> <unique> <Leader>be :Buffers<CR>
" open files directory
nmap <leader>ew :e    %:h <cr>
nmap <leader>es :sp   %:h <cr>
nmap <leader>ev :vsp  %:h <cr>
nmap <leader>et :tabe %:h <cr>
"--------------------------------------------------------------

"--------------------------------------------------------------
" appearance
"--------------------------------------------------------------
set t_Co=256 " vim uses 256 colors
set background=dark
colorscheme gruvbox

source ~/.vim/my_lightline.vim

let NERDTreeShowHidden=1 " show hidden files in NERDTree by default
"--------------------------------------------------------------

"--------------------------------------------------------------
" highlighting
"--------------------------------------------------------------
" toggle display of (tabs etc, trailing spaces)
function ToggleListTrailingSpacesDisplay()
  if &list
    set nolist
    highlight CustomHighlight_TrailingSpace NONE
  else
    set list
    highlight CustomHighlight_TrailingSpace term=standout cterm=bold ctermfg=235 ctermbg=167 gui=bold guifg=#282828 guibg=#fb4934
  endif
  call lightline#update()
endfunction
call ToggleListTrailingSpacesDisplay()

" highlight non breakable space
set listchars=nbsp:?

" highlight trailing spaces
autocmd BufWinEnter * match CustomHighlight_TrailingSpace /\s\+$/
autocmd InsertEnter * match CustomHighlight_TrailingSpace /\s\+\%#\@<!$/
autocmd InsertLeave * match CustomHighlight_TrailingSpace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" redefine Todo highlight group for more readability
highlight Todo term=standout cterm=bold ctermfg=235 ctermbg=167 gui=bold guifg=#282828 guibg=#fb4934

" always highlight TODO and FIXME no matter the filetype
highlight link CustomHighlight_Warning Todo
autocmd WinEnter,VimEnter * :silent! call matchadd('CustomHighlight_Warning', 'TODO\|FIXME', -1)
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
let g:ycm_python_binary_path = 'python3'

command! EnableYCM call EnableYCM()
function EnableYCM()
  if !exists( "g:loaded_youcompleteme" )
    call plug#load('YouCompleteMe')
    nnoremap <leader>g :YcmCompleter GoTo<CR>
    nnoremap <leader>pd :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>pc :YcmCompleter GoToDeclaration<CR>
    echom "YouCompleteMe loaded (" . g:ycm_python_binary_path . ")."
  else
    if g:ycm_python_binary_path == "python3"
      let g:ycm_python_binary_path = "python"
    else
      let g:ycm_python_binary_path = "python3"
    endif
    execute "YcmCompleter RestartServer " . g:ycm_python_binary_path
    echom "YouCompleteMe restarted (" . g:ycm_python_binary_path . ")."
  endif
endfunction

function! DisplayDoc()
  if &filetype == "python"
    call EnableYCM()
    YcmCompleter GetDoc
  else
    execute "Man " . expand('<cword>')
  endif
endfunction
"--------------------------------------------------------------

"--------------------------------------------------------------
" verilog
"--------------------------------------------------------------
" add UVM tags
set tags+=~/.vim/tags/UVM_CDNS-1.1d

" map '-' to 'begin end' surrounding
autocmd FileType verilog_systemverilog let b:surround_45 = "begin \r end"

" verilog_systemverilog mappings
nnoremap <leader>i :VerilogFollowInstance<CR>
nnoremap <leader>I :VerilogFollowPort<CR>

" commentary
autocmd FileType verilog_systemverilog setlocal commentstring=//%s

let g:verilog_instance_skip_last_coma = 1
"--------------------------------------------------------------

"--------------------------------------------------------------
" cpp
"--------------------------------------------------------------
" override default indent based on plugin
autocmd FileType c,cpp setlocal shiftwidth=4

" Make opens a 3 line error window if any errors
command -nargs=* Make make <args> | cwindow 3
"--------------------------------------------------------------

"--------------------------------------------------------------
" misc
"--------------------------------------------------------------
" redirection of vim commands in clipboard
command! -nargs=1 RediCmdToClipboard call RediCmdToClipboard(<f-args>)
function! RediCmdToClipboard(cmd)
  let a = 'redi @* | ' . a:cmd . ' | redi END'
  execute a
endfunction

" set ft=sh for *.bashrc files
au BufNewFile,BufRead *.bashrc* call SetFileTypeSH("bash")

" simple gvim
set guioptions-=m "remove menu bar
set guioptions-=T "remove toolbar
set guioptions-=r "remove right-hand scroll bar
set guioptions-=L "remove left-hand scroll bar

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

" open window with results for grep
autocmd QuickFixCmdPost *grep* copen

" add filetype for custom file
au BufNewFile,BufRead *.tabasco set filetype=conf2
"--------------------------------------------------------------
