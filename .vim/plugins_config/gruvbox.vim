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

let g:fzf_colors = extend({'gutter':  ['fg', 'GruvboxBg0']} ,g:fzf_colors)

let g:lightline#colorscheme#my_gruvbox#palette = {'inactive': {'right': [['#a89984', '#504945', '246', '239']], 'middle': [['#a89984', '#504945', '246', '239']], 'left': [['#a89984', '#504945', '246', '239']]}, 'replace': {'right': [['#32302f', '#8ec07c', '236', '108'], ['#ebdbb2', '#504945', '223', '239']], 'middle': [['#a89984', '#3c3836', '246', '237']], 'left': [['#32302f', '#8ec07c', '236', '108', 'bold'], ['#ebdbb2', '#504945', '223', '239']]}, 'normal': {'right': [['#32302f', '#a89984', '236', '246'], ['#a89984', '#504945', '246', '239']], 'middle': [['#a89984', '#3c3836', '246', '237']], 'warning': [['#32302f', '#fabd2f', '236', '214']], 'left': [['#32302f', '#a89984', '236', '246', 'bold'], ['#a89984', '#504945', '246', '239']], 'error': [['#32302f', '#fb4934', '236', '167']]}, 'terminal': {'right': [['#32302f', '#b8bb26', '236', '142'], ['#ebdbb2', '#504945', '223', '239']], 'middle': [['#a89984', '#3c3836', '246', '237']], 'left': [['#32302f', '#b8bb26', '236', '142', 'bold'], ['#ebdbb2', '#504945', '223', '239']]}, 'tabline': {'right': [['#32302f', '#fe8019', '236', '208']], 'middle': [['#32302f', '#7c6f64', '236', '243']], 'left': [['#a89984', '#504945', '246', '239']], 'tabsel': [['#32302f', '#a89984', '236', '246']]}, 'visual': {'right': [['#32302f', '#fe8019', '236', '208'], ['#32302f', '#7c6f64', '236', '243']], 'middle': [['#a89984', '#3c3836', '246', '237']], 'left': [['#32302f', '#fe8019', '236', '208', 'bold'], ['#32302f', '#7c6f64', '236', '243']]}, 'insert': {'right': [['#32302f', '#83a598', '236', '109'], ['#ebdbb2', '#504945', '223', '239']], 'middle': [['#a89984', '#3c3836', '246', '237']], 'left': [['#32302f', '#83a598', '236', '109', 'bold'], ['#ebdbb2', '#504945', '223', '239']]}}
