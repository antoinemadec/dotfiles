let g:fzf_commands_expect = 'alt-enter'
command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'), <bang>0)

" popup windows
if has('nvim')
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif

" Maps can receive mode argument. E.g.: Maps i
function s:maps(mode, ...) abort
  let l:mode = empty(a:mode) ? "n" : a:mode
  let l:a000_str = join(a:000, ',')
  exe 'call fzf#vim#maps("' . l:mode . '", ' . l:a000_str ')'
endfunction
command! -bar -bang -nargs=? Maps call s:maps(<q-args>, <bang>0)
