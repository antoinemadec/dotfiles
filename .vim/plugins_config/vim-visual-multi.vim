let g:VM_theme = 'iceblue'
let g:VM_silent_exit = 1
let g:VM_highlight_matches = ''
let g:VM_set_statusline = 0

autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"

let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '<C-S-Down>'
let g:VM_maps["Add Cursor Up"]   = '<C-S-Up>'

function! VM_Start()
  let g:VM_is_active = 1
  silent! call CocAction('deactivateExtension', 'coc-snippets')
  silent! call CocAction('deactivateExtension', 'coc-yank')
endfunction

function! VM_Exit()
  let g:VM_is_active = 0
  silent! call CocAction('activeExtension', 'coc-snippets')
  silent! call CocAction('activeExtension', 'coc-yank')
endfunction
