let g:VM_silent_exit = 1
let g:VM_highlight_matches = ''
let g:VM_set_statusline = 0
let g:VM_custom_motions  = {'<Left>': 'h', '<Down>': 'j', '<Up>': 'k', '<Right>': 'l'}

let g:VM_Extend_hl = 'VM_Extend_hl'
let g:VM_Cursor_hl = 'VM_Cursor_hl'
let g:VM_Insert_hl = 'VM_Insert_hl'
let g:VM_Mono_hl   = 'VM_Mono_hl'

autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"

autocmd BufWinEnter      * let w:VM_is_active = 0
autocmd User AsyncRunPre * let w:VM_is_active = 0

let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '<C-S-Down>'
let g:VM_maps["Add Cursor Up"]   = '<C-S-Up>'

function! VM_Start()
  let w:VM_is_active = 1
  silent! call CocAction('deactivateExtension', 'coc-snippets')
  silent! call CocAction('deactivateExtension', 'coc-yank')
endfunction

function! VM_Exit()
  let w:VM_is_active = 0
  silent! call CocAction('activeExtension', 'coc-snippets')
  silent! call CocAction('activeExtension', 'coc-yank')
endfunction
