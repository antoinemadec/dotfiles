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
Plug 'tpope/vim-repeat'                                                        " remaps '.' in a way that plugins can tap into it
Plug 'PotatoesMaster/i3-vim-syntax', {'for': 'i3'}                             " i3/config highlighting
Plug 'kshenoy/TWiki-Syntax'                                                    " Twiki highlighting
Plug 'skywind3000/asyncrun.vim'                                                " run asynchronous bash commands
Plug 'valloric/YouCompleteMe', {'on': []}                                      " fast, as-you-type, code completion engine for Vim
call plug#end()

if empty(glob("~/.vim/plugins_by_vimplug"))
  PlugInstall
endif

"--------------------------------------------------------------
" vim options
"--------------------------------------------------------------
if has('nvim')
  " TODO wait for NVIM support of clipboard=autoselect
  " in order to make mouse=a copy/paste work
  set clipboard+=unnamed
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
let &t_SI = "\e[6 q"           " allow thin cursor in insert mode
let &t_EI = "\e[2 q"           " allow thin cursor in insert mode
set t_ut=                      " do not use term color for clearing
runtime! ftplugin/man.vim      " allow man to be displayed in vim
runtime! macros/matchit.vim    " allow usage of % to match 'begin end' and other '{ }' kind of pairs

"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
if has('terminal') || has('nvim')
  tnoremap <Esc>     <C-\><C-n>
  tnoremap <expr>    <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  tnoremap <A-Left>  <C-\><C-N><C-w>h
  tnoremap <A-Down>  <C-\><C-N><C-w>j
  tnoremap <A-Up>    <C-\><C-N><C-w>k
  tnoremap <A-Right> <C-\><C-N><C-w>l
endif
inoremap <A-Left>    <C-\><C-N><C-w>h
inoremap <A-Down>    <C-\><C-N><C-w>j
inoremap <A-Up>      <C-\><C-N><C-w>k
inoremap <A-Right>   <C-\><C-N><C-w>l
inoremap <A-S-Left>  <C-\><C-N><C-w>H
inoremap <A-S-Down>  <C-\><C-N><C-w>J
inoremap <A-S-Up>    <C-\><C-N><C-w>K
inoremap <A-S-Right> <C-\><C-N><C-w>L
nnoremap <A-Left>    <C-w>h
nnoremap <A-Down>    <C-w>j
nnoremap <A-Up>      <C-w>k
nnoremap <A-Right>   <C-w>l
nnoremap <A-S-Left>  <C-w>H
nnoremap <A-S-Down>  <C-w>J
nnoremap <A-S-Up>    <C-w>K
nnoremap <A-S-Right> <C-w>L
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
nnoremap <silent> <F3>     :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
nnoremap <silent> <F4>     :ToggleYCM<CR>
nnoremap <silent> <F5>     :exe "HighlightGroupsAddWord " . hg0 . " 0"<CR>
nnoremap <silent> <F6>     :exe "HighlightGroupsAddWord " . hg1 . " 0"<CR>
nnoremap <silent> <S-F5>   :exe "HighlightGroupsClearGroup " . hg0 . " 0"<CR>
nnoremap <silent> <S-F6>   :exe "HighlightGroupsClearGroup " . hg1 . " 0"<CR>
nnoremap <silent> <C-F5>   :exe "HighlightGroupsAddWord " . hg0 . " 1"<CR>
nnoremap <silent> <C-F6>   :exe "HighlightGroupsAddWord " . hg1 . " 1"<CR>
nnoremap <silent> <C-S-F5> :exe "HighlightGroupsClearGroup " . hg0 . " 1"<CR>
nnoremap <silent> <C-S-F6> :exe "HighlightGroupsClearGroup " . hg1 . " 1"<CR>
nnoremap <silent> <F8>     :call ToggleListTrailingSpacesDisplay()<CR>
nnoremap <silent> <F9>     :set spell!<CR>
inoremap <silent> <F9>     <C-o>:set spell!<CR>
noremap <F10>              :call asyncrun#quickfix_toggle(8)<cr>
" paste avoiding auto indentation
set pastetoggle=<F12>
nnoremap <script> <silent> <unique> <Leader>be :Buffers<CR>
" open files directory
nnoremap <leader>ew :e    %:h <cr>
nnoremap <leader>es :sp   %:h <cr>
nnoremap <leader>ev :vsp  %:h <cr>
nnoremap <leader>et :tabe %:h <cr>
" run current buffer
nnoremap <leader>r :RunCurrentBuffer <cr>

"--------------------------------------------------------------
" appearance
"--------------------------------------------------------------
if has('termguicolors')
  set termguicolors
  let hg0 = 13
  let hg1 = 17
else
  set t_Co=256 " vim uses 256 colors
  let hg0 = 4
  let hg1 = 6
endif
set background=dark
let g:gruvbox_italic=1
colorscheme gruvbox
highlight Todo      term=standout cterm=bold ctermfg=235 ctermbg=167 gui=bold guifg=#282828 guibg=#fb4934

source ~/.vim/my_lightline.vim

"--------------------------------------------------------------
" highlighting
"--------------------------------------------------------------
" toggle display of (tabs etc, trailing spaces)
function ToggleListTrailingSpacesDisplay()
  if &list
    windo set nolist
    highlight CustomHighlight_TrailingSpace NONE
  else
    windo set list
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

" always highlight TODO and FIXME no matter the filetype
highlight link CustomHighlight_Warning Todo
autocmd WinEnter,VimEnter * :silent! call matchadd('CustomHighlight_Warning', 'TODO\|FIXME', -1)

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
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_python_binary_path = 'python3'

command! ToggleYCM call ToggleYCM()
function ToggleYCM()
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
    let l:pydoc = g:ycm_python_binary_path == 'python3' ? 'pydoc3 ' : 'pydoc'
    let l:pydoc_stdout = system(l:pydoc . " " . expand('<cword>'))
    if l:pydoc_stdout[1:32] != "o Python documentation found for"
      Scratch | 0 put =l:pydoc_stdout | normal gg
      set ft=man
    else
      if !exists( "g:loaded_youcompleteme" )
        call ToggleYCM()
      endif
      YcmCompleter GetDoc
      wincmd k
      if line('$') == 1 && getline(1) == ''
        q
      endif
    endif
  else
    execute "Man " . expand('<cword>')
  endif
endfunction

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
" cpp
"--------------------------------------------------------------
" override default indent based on plugin
autocmd FileType c,cpp setlocal shiftwidth=4

"--------------------------------------------------------------
" misc
"--------------------------------------------------------------
" redirection of vim commands in clipboard
command! -nargs=1 RediCmdToClipboard call RediCmdToClipboard(<f-args>)
function! RediCmdToClipboard(cmd)
  let a = 'redi @* | ' . a:cmd . ' | redi END'
  execute a
endfunction

" open scratch buffer
command! -bar -nargs=0 Scratch new | setlocal buftype=nofile bufhidden=hide noswapfile

" AsyncRun
command! -nargs=* -complete=shellcmd Run AsyncRun <args>
command! -nargs=0 RunCurrentBuffer :w | execute("AsyncRun " . expand('%:p') . "; sleep .1")
command! -bang -nargs=* -complete=file Grep AsyncRun -program=grep @ <args>
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" set ft=sh for *.bashrc files
au BufNewFile,BufRead *.bashrc* set ft=sh

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
if has('terminal')
  command! -nargs=* T terminal <args>
  command! -nargs=* VT terminal <args>
endif

" automate opening quickfix window when text adds to it
autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(8, 1)

" add filetype for custom file
au BufNewFile,BufRead *.tabasco set filetype=conf2
