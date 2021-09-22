let g:tagbar_width = 30
let g:tagbar_ctags_bin = 'uctags'
let g:tagbar_sort=0

let g:tagbar_no_status_line = 1

let g:tagbar_stl_verilog_systemverilog = v:true

" These keymaps will jump to the next/prev tag regardless of type, and
" will also use the jump_offset configuration to position the cursor
nnoremap <silent> ]t :call tagbar#jumpToNearbyTag(1, 'nearest', 's')<CR>
nnoremap <silent> [t :call tagbar#jumpToNearbyTag(-1, 'nearest', 's')<CR>
