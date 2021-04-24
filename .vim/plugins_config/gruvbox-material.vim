autocmd VimEnter * call s:set_hilights()

function s:set_hilights() abort
  hi Todo ctermfg=167 guifg=#f2594b gui=reverse,bold cterm=reverse,bold
  hi Ignore None
endfunction
