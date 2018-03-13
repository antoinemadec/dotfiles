" appearance
set guioptions+=T "toolbar for file open
set guifont=Consolas:h10:cANSI

" diff
set diffexpr=MyDiff()
function MyDiff()
  let opt = ''
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  silent execute '!"'.$VIMRUNTIME.'\diff" -a ' . opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
endfunction

" terminal
if has('terminal')
  command! T  call term_start('C:\Program Files\Git\bin\bash.exe', {"term_finish": "close"})
  command! TV call term_start('C:\Program Files\Git\bin\bash.exe', {"term_finish": "close", "vertical": 1})
  command! TT tab call term_start('C:\Program Files\Git\bin\bash.exe', {"term_finish": "close"})
endif

" misc
set belloff=all
