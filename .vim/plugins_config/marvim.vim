let g:marvim_store = $HOME."/.vim/marvim"
let g:marvim_find_key = ''
let g:marvim_store_key = ''
let g:macro_debug_cnt = 0
command! MacroStore call marvim#macro_store()
command! MacroLoad call marvim#search()
