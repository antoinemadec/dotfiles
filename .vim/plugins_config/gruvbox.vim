function s:set_highlight(name, bg, fg, extra_opts, ...) abort
  let mod = a:0 ? a:1 : 0
  let bg_str = ''
  let fg_str = ''
  let opts_str = ''
  if !empty(a:bg)
    exe 'let bg = g:current_gruvbox_colors.' . a:bg
    if mod
      let bg[0] = '#' . printf('%x', '0x' . bg[0][1:] - 1)
      let bg[1] = bg[1]-1
    endif
    let bg_str = ' guibg=' . bg[0] . ' ctermbg=' . bg[1]
  endif
  if !empty(a:fg)
    exe 'let fg = g:current_gruvbox_colors.' . a:fg
    let fg_str = ' guifg=' . fg[0] . ' ctermfg=' . fg[1]
  endif
  if !empty(a:extra_opts)
    let opts_str = ''
    for ui in ['cterm', 'gui']
      exe printf('let opts_str .= " %s=%s"', ui, join(a:extra_opts, ','))
    endfor
  endif
  exe 'highlight ' . a:name . fg_str . bg_str . opts_str
endfunction

" make sure StatusLineNC and StatusLine are not identical to avoid ^^^^^
call s:set_highlight('StatusLineNC',     'fg1',           'bg2',         ['reverse'], -1)
call s:set_highlight('CocHighlightText', 'bg2',           '',            '')
call s:set_highlight('Todo',             'bright_red',    'dark0_hard',  ['bold'])
call s:set_highlight('VertSplit',        'bg0',           'dark0_hard',  '')
call s:set_highlight('VM_Extend_hl',     'faded_blue',    '',            '')
call s:set_highlight('VM_Cursor_hl',     'neutral_blue',  'bright_aqua', '')
call s:set_highlight('VM_Insert_hl',     'gray',          ''           , '')
call s:set_highlight('VM_Mono_hl',       'bright_orange', 'fg0',         ['bold'])

hi link illuminatedWord CocHighlightText
hi link CocGitDiffDelete GruvboxRedSign
hi link CocGitDiffAdd GruvboxGreenSign
hi link CocGitDiffChange GruvboxAquaSign
hi link Sneak VM_Mono_hl
hi link SneakLabel VM_Mono_hl

" 'light4':         #a89984
" 'neutral_green':  #98971a
" 'yellow':         #fabd2f
" 'faded_aqua':     #427b58
" 'bright_blue':    #83a598
" 'orange':         #fe8019
" 'neutral_blue':   #458588
" 'purple':         #d3869b
" 'faded_green':    #79740e
" 'neutral_red':    #cc241d
" 'gray_244':       #928374
" 'gray_245':       #928374
" 'bright_yellow':  #fabd2f
" 'fg4_256':        #a89984
" 'fg0':            #fbf1c7
" 'fg1':            #ebdbb2
" 'fg2':            #d5c4a1
" 'fg3':            #bdae93
" 'fg4':            #a89984
" 'bright_purple':  #d3869b
" 'neutral_orange': #d65d0e
" 'bright_orange':  #fe8019
" 'faded_red':      #9d0006
" 'light0_soft':    #f2e5bc
" 'blue':           #83a598
" 'faded_blue':     #076678
" 'light0_hard':    #f9f5d7
" 'bright_green':   #b8bb26
" 'gray':           #928374
" 'dark4_256':      #7c6f64
" 'neutral_purple': #b16286
" 'dark0':          #282828
" 'dark1':          #3c3836
" 'dark2':          #504945
" 'dark3':          #665c54
" 'dark4':          #7c6f64
" 'dark0_soft':     #32302f
" 'bright_aqua':    #8ec07c
" 'neutral_aqua':   #689d6a
" 'dark0_hard':     #1d2021
" 'light4_256':     #a89984
" 'green':          #b8bb26
" 'neutral_yellow': #d79921
" 'aqua':           #8ec07c
" 'faded_yellow':   #b57614
" 'red':            #fb4934
" 'faded_purple':   #8f3f71
" 'bg0':            #32302f
" 'bg1':            #3c3836
" 'bg2':            #504945
" 'bg3':            #665c54
" 'bg4 ':           #7c6f64
" 'bright_red':     #fb4934
" 'faded_orange':   #af3a03
" 'light0':         #fbf1c7
" 'light1':         #ebdbb2
" 'light2':         #d5c4a1
" 'light3':         #bdae93
