vim.cmd([[
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

if has('nvim')
  autocmd BufWinEnter,InsertLeave,TermLeave * call MatchUpdate('trailingspace', 'CustomHighlight_TrailingSpace', '\s\+$',        11, v:false)
  autocmd InsertEnter,TermEnter             * call MatchUpdate('trailingspace', 'CustomHighlight_TrailingSpace', '\s\+\%#\@<!$', 11, v:false)
else
  autocmd BufWinEnter,InsertLeave * call MatchUpdate('trailingspace', 'CustomHighlight_TrailingSpace', '\s\+$',        11, v:false)
  autocmd InsertEnter             * call MatchUpdate('trailingspace', 'CustomHighlight_TrailingSpace', '\s\+\%#\@<!$', 11, v:false)
endif

" highlight non breakable space
set listchars=nbsp:?

" always highlight TBD TODO and FIXME no matter the filetype
highlight link CustomHighlight_Warning Todo
autocmd WinEnter,VimEnter * call MatchUpdate('todo', 'CustomHighlight_Warning', 'TBD\|TODO\|FIXME', 11, v:true)

" highlight current line
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

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
  au TermOpen * setlocal nonumber norelativenumber
endif

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
function MatchUpdate(id_str, hl, pattern, priority, enable_buf) abort
  call MatchDelete(a:id_str)
  if empty(&buftype) || a:enable_buf
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

" help
command -complete=help -nargs=* H tab help <args>
]])
