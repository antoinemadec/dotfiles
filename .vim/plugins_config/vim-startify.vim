let g:startify_custom_header = [
      \ '    __      ___',
      \ '    \ \    / (_)',
      \ '     \ \  / / _ _ __ ___',
      \ '      \ \/ / | |  _ ` _ \',
      \ '       \  /  | | | | | | |',
      \ '        \/   |_|_| |_| |_|',
      \]
let g:startify_commands = [':Files',
      \ ':Scratch tab',
      \ ':PlugClean' ,
      \ ':PlugInstall | CocInstall',
      \ ':PlugUpdate  | CocUpdate']
let g:startify_lists = [
      \ { 'type': 'commands',  'indices': ['f', 's', 'c', 'i', 'u'] },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ ]
let g:startify_change_to_dir = 0
