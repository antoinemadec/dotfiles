let g:startify_custom_header = [
      \ ' __      ___',
      \ ' \ \    / (_)',
      \ '  \ \  / / _ _ __ ___',
      \ '   \ \/ / | |  _ ` _ \',
      \ '    \  /  | | | | | | |',
      \ '     \/   |_|_| |_| |_|',
      \]
let g:startify_commands = [':Files',
      \ ':Scratch',
      \ ':PlugClean' ,
      \ ':PlugInstall | CocInstall',
      \ ':PlugUpdate  | CocUpdate']
let g:startify_lists = [
      \ { 'type': 'commands',  'indices': ['f', 's', 'c', 'i', 'u'] },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ ]
let g:startify_change_to_dir = 0

let g:matchup_matchparen_status_offscreen = 0

let g:webdevicons_enable_startify = 0
function! StartifyEntryFormat()
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) . "  " . entry_path'
endfunction
