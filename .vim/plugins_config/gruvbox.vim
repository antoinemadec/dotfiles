function s:set_highlight(name, fg, bg, extra_opts) abort
  let fg_str = ''
  let bg_str = ''
  let opts_str = ' ' . a:extra_opts
  if !empty(a:fg)
    let fg_str = ' guifg=' . a:fg[0] . ' ctermfg=' . a:fg[1]
  endif
  if !empty(a:bg)
    let bg_str = ' guibg=' . a:bg[0] . ' ctermbg=' . a:bg[1]
  endif
  exe 'highlight ' . a:name . fg_str . bg_str . opts_str
endfunction

let s:bg0 = g:current_gruvbox_colors.bg0
let s:bg2 = g:current_gruvbox_colors.bg2
let s:fg0 = g:current_gruvbox_colors.fg0
let s:fg1 = g:current_gruvbox_colors.fg1
let s:bright_red = g:current_gruvbox_colors.bright_red
let s:bright_orange = g:current_gruvbox_colors.bright_orange
let s:bright_yellow = g:current_gruvbox_colors.bright_yellow
let s:bright_green = g:current_gruvbox_colors.bright_green
let s:bright_blue = g:current_gruvbox_colors.bright_blue
let s:bright_aqua = g:current_gruvbox_colors.bright_aqua
let s:dark0_hard = g:current_gruvbox_colors.dark0_hard

" fg[1]-1: make sure StatusLineNC and StatusLine are not identical to avoid ^^^^^
exe 'hi StatusLineNC cterm=reverse ctermfg=' . s:bg2[1] . ' ctermbg=' . string(s:fg1[1]-1) .
      \ ' gui=reverse guifg=' . s:bg2[0] . ' guibg=' . s:fg1[0]
call s:set_highlight('CocHighlightText', '', s:bg2, '')
call s:set_highlight('Todo', s:dark0_hard, s:bright_red, 'term=standout cterm=bold gui=bold')
call s:set_highlight('VertSplit', s:dark0_hard, s:bg0, '')
call s:set_highlight('VM_Mono_hl', s:fg0, s:bright_red, 'cterm=bold term=bold gui=bold')

hi link illuminatedWord CocHighlightText
hi link CocGitDiffDelete GruvboxRedSign
hi link CocGitDiffAdd GruvboxGreenSign
hi link CocGitDiffChange GruvboxAquaSign
