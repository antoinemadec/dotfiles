let s:bg0 = g:current_gruvbox_colors.bg0
let s:bg2 = g:current_gruvbox_colors.bg2
let s:fg1 = g:current_gruvbox_colors.fg1
let s:bright_red = g:current_gruvbox_colors.bright_red
let s:dark_hard = g:current_gruvbox_colors.dark0_hard

" fg[1]-1: make sure StatusLineNC and StatusLine are not identical to avoid ^^^^^
exe 'hi StatusLineNC cterm=reverse ctermfg=' . s:bg2[1] . ' ctermbg=' . string(s:fg1[1]-1) .
      \ ' gui=reverse guifg=' . s:bg2[0] . ' guibg=' . s:fg1[0]
exe 'hi CocHighlightText ctermbg=' . s:bg2[1] ' guibg=' . s:bg2[0]

exe 'hi Todo term=standout cterm=bold ctermfg=' . s:dark_hard[1] . ' ctermbg=' . s:bright_red[1] .
      \ ' gui=bold guifg=' . s:dark_hard[0] . ' guibg=' . s:bright_red[0]
exe 'hi VertSplit guibg=' . s:bg0[0] . ' guifg=#181A1F'
