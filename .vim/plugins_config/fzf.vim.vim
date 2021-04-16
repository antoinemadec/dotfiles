let g:fzf_layout = {'window': { 'width': 0.9, 'height': 0.8, 'border': 'sharp' } }
" let g:fzf_colors = extend({'border':  ['fg', 'Comment']} ,g:fzf_colors)
let g:fzf_commands_expect = 'alt-enter'
let g:coc_fzf_preview = 'right:50%'
let g:coc_fzf_opts = []

command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>, '--follow', fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'), <bang>0)

command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number -- '.shellescape(<q-args>), 0,
      \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0], 'options': '--delimiter : --nth 3..'}), <bang>0)

" Maps can receive mode argument. E.g.: Maps i
function s:maps(mode, ...) abort
  let l:mode = empty(a:mode) ? "n" : a:mode
  let l:a000_str = join(a:000, ',')
  exe 'call fzf#vim#maps("' . l:mode . '", ' . l:a000_str ')'
endfunction
command! -bar -bang -nargs=? Maps call s:maps(<q-args>, <bang>0)
