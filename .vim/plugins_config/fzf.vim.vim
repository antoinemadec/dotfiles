let g:fzf_commands_expect = 'alt-enter'
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'), <bang>0)

" popup windows
if has('nvim')
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif
