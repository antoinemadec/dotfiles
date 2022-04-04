nnoremap <buffer> <leader>u :VerilogGotoInstanceStart<CR>
nnoremap <buffer> <leader>i :VerilogFollowInstance<CR>
nnoremap <buffer> <leader>I :VerilogFollowPort<CR>

setlocal commentstring=//%s

if exists('g:uvm_ctags_path_loaded')
  finish
else
  let g:uvm_ctags_path_loaded = 'yes'
  set tags+=~/.vim/tags/UVM_CDNS-1.2
endif
