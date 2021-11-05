require('plugins')
require('options')

vim.cmd([[
" highlight current line
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

au TermOpen * setlocal nonumber norelativenumber

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
let g:gruvbox_material_background = 'soft'
let g:gruvbox_material_better_performance = 1
set rtp+=~/.local/share/nvim/site/pack/packer/start/gruvbox-material/after
let g:gruvbox_material_palette = 'mix'
colorscheme gruvbox-material
set fillchars=vert:│,fold:+

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

autocmd BufWinEnter * call MatchUpdate('trailingspace',
      \ 'CustomHighlight_TrailingSpace',  '\s\+$', 11)
autocmd InsertEnter * call MatchUpdate('trailingspace',
      \ 'CustomHighlight_TrailingSpace', '\s\+\%#\@<!$', 11)
autocmd InsertLeave * call MatchUpdate('trailingspace',
      \ 'CustomHighlight_TrailingSpace',  '\s\+$', 11)

" highlight non breakable space
set listchars=nbsp:?

" always highlight TBD TODO and FIXME no matter the filetype
highlight link CustomHighlight_Warning Todo
autocmd WinEnter,VimEnter * call MatchUpdate('todo',
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
  command! T terminal
  command! TS split | terminal
  command! TV vsplit | terminal
  command! TT tabe | terminal

"--------------------------------------------------------------
" misc
"--------------------------------------------------------------
" start vim server
if exists('*remote_startserver') && has('clientserver') && v:servername == ''
  call remote_startserver('vim_server_' . getpid())
endif

function MatchUpdate(id_str, hl, pattern, priority) abort
  call MatchDelete(a:id_str)
  if &filetype != 'which_key'
    call MatchAdd(a:id_str, a:hl, a:pattern, a:priority)
  endif
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

" windows options
if has('win32') && filereadable($HOME.'\.vim\windows.vim')
  source ~/.vim/windows.vim
endif

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
    let is_already_floating = nvim_win_get_config(0).relative != ''
    if !is_already_floating
      let buf = nvim_create_buf(v:false, v:false)
      call nvim_open_win(buf, v:true, config)
    endif
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
]])
