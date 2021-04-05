let g:current_gruvbox_colors = {'light4': ['#a89984', 246], 'neutral_green': ['#98971a', 106], 'yellow': ['#fabd2f', 214], 'faded_aqua': ['#427b58', 65], 'bright_blue': ['#83a598', 109], 'orange': ['#fe8019', 208], 'neutral_blue': ['#458588', 66], 'purple': ['#d3869b', 175], 'faded_green': ['#79740e', 100], 'neutral_red': ['#cc241d', 124], 'gray_244': ['#928374', 244], 'gray_245': ['#928374', 245], 'bright_yellow': ['#fabd2f', 214], 'fg4_256': ['#a89984', 246], 'fg0': ['#fbf1c7', 229], 'fg1': ['#ebdbb1', 222], 'fg2': ['#d5c4a1', 250], 'fg3': ['#bdae93', 248], 'fg4': ['#a89984', 246], 'bright_purple': ['#d3869b', 175], 'neutral_orange': ['#d65d0e', 166], 'bright_orange': ['#fe8019', 208], 'faded_red': ['#9d0006', 88], 'light0_soft': ['#f2e5bc', 228], 'blue': ['#83a598', 109], 'faded_blue': ['#076678', 24], 'light0_hard': ['#f9f5d7', 230], 'bright_green': ['#b8bb26', 142], 'gray': ['#928374', 245], 'dark4_256': ['#7c6f64', 243], 'neutral_purple': ['#b16286', 132], 'dark0': ['#282828', 235], 'dark1': ['#3c3836', 237], 'dark2': ['#504945', 239], 'dark3': ['#665c54', 241], 'dark4': ['#7c6f64', 243], 'dark0_soft': ['#32302f', 236], 'bright_aqua': ['#8ec07c', 108], 'neutral_aqua': ['#689d6a', 72], 'dark0_hard': ['#1d2021', 234], 'light4_256': ['#a89984', 246], 'green': ['#b8bb26', 142], 'neutral_yellow': ['#d79921', 172], 'aqua': ['#8ec07c', 108], 'faded_yellow': ['#b57614', 136], 'red': ['#fb4934', 167], 'faded_purple': ['#8f3f71', 96], 'bg0': ['#32302f', 236], 'bg1': ['#3c3836', 237], 'bg2': ['#504945', 239], 'bg3': ['#665c54', 241], 'bg4': ['#7c6f64', 243], 'bright_red': ['#fb4934', 167], 'faded_orange': ['#af3a03', 130], 'light0': ['#fbf1c7', 229], 'light1': ['#ebdbb1', 222], 'light2': ['#d5c4a1', 250], 'light3': ['#bdae93', 248]}

hi GruvboxRedSign    ctermfg=167 ctermbg=237 guifg=#fb4934 guibg=#3c3836
hi GruvboxBlueSign   ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
hi GruvboxGreenSign  ctermfg=142 ctermbg=237 guifg=#b8bb26 guibg=#3c3836
hi GruvboxAquaSign   ctermfg=108 ctermbg=237 guifg=#8ec07c guibg=#3c3836
hi GruvboxOrangeSign ctermfg=208 ctermbg=237 guifg=#fe8019 guibg=#3c3836

hi GruvboxBg0    ctermfg=236 guifg=#32302f
hi GruvboxBg1    ctermfg=237 guifg=#3c3836
hi GruvboxBg3    ctermfg=241 guifg=#665c54
hi GruvboxFg1    ctermfg=223 guifg=#ebdbb2
hi GruvboxFg4    ctermfg=246 guifg=#a89984
hi GruvboxYellow ctermfg=214 guifg=#fabd2f
hi GruvboxRed    ctermfg=167 guifg=#fb4934
hi GruvboxBlue   ctermfg=109 guifg=#83a598
hi GruvboxGreen  ctermfg=142 guifg=#b8bb26
hi GruvboxAqua   ctermfg=108 guifg=#8ec07c
hi GruvboxOrange ctermfg=208 guifg=#fe8019

hi default link CocErrorSign    GruvboxRedSign
hi default link CocWarningSign  GruvboxOrangeSign
hi default link CocInfoSign     GruvboxBlueSign
hi default link CocHintSign     GruvboxAquaSign
hi default link CocErrorFloat   GruvboxRed
hi default link CocWarningFloat GruvboxOrange
hi default link CocInfoFloat    GruvboxBlue
hi default link CocHintFloat    GruvboxAqua

hi netrwDir guifg=#8ec07c guibg=NONE gui=NONE cterm=NONE
hi netrwClassify guifg=#8ec07c guibg=NONE gui=NONE cterm=NONE
hi netrwLink guifg=#928374 guibg=NONE gui=NONE cterm=NONE
hi netrwSymLink guifg=#ebdbb2 guibg=NONE gui=NONE cterm=NONE
hi netrwExe guifg=#fabd2f guibg=NONE gui=NONE cterm=NONE
hi netrwComment guifg=#928374 guibg=NONE gui=NONE cterm=NONE
hi netrwList guifg=#83a598 guibg=NONE gui=NONE cterm=NONE
hi netrwHelpCmd guifg=#8ec07c guibg=NONE gui=NONE cterm=NONE
hi netrwCmdSep guifg=#bdae93 guibg=NONE gui=NONE cterm=NONE
hi netrwVersion guifg=#b8bb26 guibg=NONE gui=NONE cterm=NONE

hi StartifyBracket guifg=#bdae93 guibg=NONE gui=NONE cterm=NONE
hi StartifyFile guifg=#ebdbb2 guibg=NONE gui=NONE cterm=NONE
hi StartifyNumber guifg=#83a598 guibg=NONE gui=NONE cterm=NONE
hi StartifyPath guifg=#928374 guibg=NONE gui=NONE cterm=NONE
hi StartifySlash guifg=#928374 guibg=NONE gui=NONE cterm=NONE
hi StartifySection guifg=#fabd2f guibg=NONE gui=NONE cterm=NONE
hi StartifySpecial guifg=#504945 guibg=NONE gui=NONE cterm=NONE
hi StartifyHeader guifg=#fe8019 guibg=NONE gui=NONE cterm=NONE
hi StartifyFooter guifg=#504945 guibg=NONE gui=NONE cterm=NONE

let fzf_colors = {'bg+': ['fg', 'GruvboxBg1'], 'bg': ['fg', 'GruvboxBg0'], 'spinner': ['fg', 'GruvboxYellow'], 'hl': ['fg', 'GruvboxYellow'], 'fg': ['fg', 'GruvboxFg1'], 'header': ['fg', 'GruvboxBg3'], 'info': ['fg', 'GruvboxBlue'], 'pointer': ['fg', 'GruvboxBlue'], 'fg+': ['fg', 'GruvboxFg1'], 'gutter': ['fg', 'GruvboxBg0'], 'marker': ['fg', 'GruvboxOrange'], 'prompt': ['fg ', 'GruvboxFg4'], 'hl+': ['fg', 'GruvboxYellow']}

source ~/.vim/plugins_config/gruvbox.vim
