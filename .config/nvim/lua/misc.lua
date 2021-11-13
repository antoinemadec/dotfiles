vim.cmd([[
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

" highlight current line
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

"--------------------------------------------------------------
" terminal
"--------------------------------------------------------------
command! T terminal
command! TS split | terminal
command! TV vsplit | terminal
command! TT tabe | terminal
au TermOpen * setlocal nonumber norelativenumber

"--------------------------------------------------------------
" text ojects
"--------------------------------------------------------------
xnoremap il g_o^
onoremap il :normal vil<CR>
xnoremap al g_o^
onoremap al :normal vil<CR>

onoremap <silent>ai :<C-U>cal IndTxtObj(0)<CR>
onoremap <silent>ii :<C-U>cal IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-U>cal IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-U>cal IndTxtObj(1)<CR><Esc>gv

function! IndTxtObj(inner)
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") !~ "^\\s*$"
    let p = line(".") - 1
    let nextblank = getline(p) =~ "^\\s*$"
    while p > 0 && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      -
      let p = line(".") - 1
      let nextblank = getline(p) =~ "^\\s*$"
    endwhile
    normal! 0V
    call cursor(curline, 0)
    let p = line(".") + 1
    let nextblank = getline(p) =~ "^\\s*$"
    while p <= lastline && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      +
      let p = line(".") + 1
      let nextblank = getline(p) =~ "^\\s*$"
    endwhile
    normal! $
  endif
endfunction

"--------------------------------------------------------------
" misc
"--------------------------------------------------------------
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

" help
command -complete=help -nargs=* Ht tab help <args>
]])
