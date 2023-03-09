vim.cmd([[
let g:VM_theme = 'iceblue'
let g:VM_silent_exit = 1
let g:VM_highlight_matches = ''
let g:VM_set_statusline = 0

autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"

" handle VM mappings in mappings.lua
let g:VM_maps = {}

function! VM_Start()
  let g:VM_is_active = 1
  silent! call CocAction('deactivateExtension', 'coc-snippets')
  silent! call CocAction('deactivateExtension', 'coc-yank')
  let g:VM_BS_map_save = maparg('<BS>', 'i', 0, 1)
endfunction

function! VM_Exit()
  let g:VM_is_active = 0
  silent! call CocAction('activeExtension', 'coc-snippets')
  silent! call CocAction('activeExtension', 'coc-yank')
  exe (g:VM_BS_map_save.noremap ? 'inoremap' : 'imap') .
  \ (g:VM_BS_map_save.buffer ? ' <buffer> ' : '') .
  \ (g:VM_BS_map_save.expr ? ' <expr> ' : '') .
  \ (g:VM_BS_map_save.nowait ? ' <nowait> ' : '') .
  \ (g:VM_BS_map_save.silent ? ' <silent> ' : '') .
  \ ' <BS> ' .
  \ g:VM_BS_map_save.rhs
endfunction
]])
