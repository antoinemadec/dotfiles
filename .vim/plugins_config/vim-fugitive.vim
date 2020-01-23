function! ToggleGstatus()
  let t = 1
  let tabs_nb = tabpagenr('$')
  while t <= tabs_nb
    if gettabvar(t, 'tabname') == 'git_status'
      break
    endif
    let t += 1
  endwhile
  if t <= tabs_nb
    if t == tabpagenr()
      " git_status is current tab: close it
      tabclose
    else
      " git_status is not current tab: jump
      exe 'tabn ' . t
    endif
  else
    " git_status does not exist: create it
    Gtabedit :
    set previewwindow
    let t:tabname = 'git_status'
  endif
endfunction
