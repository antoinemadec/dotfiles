nnoremap <buffer> <leader>u :VerilogGotoInstanceStart<CR>
nnoremap <buffer> <leader>i :VerilogFollowInstance<CR>
nnoremap <buffer> <leader>I :VerilogFollowPort<CR>

setlocal commentstring=//%s

let g:uvm_tags_is_on = 0
let g:uvm_tags_path = "~/.vim/tags/UVM_CDNS-1.2"
command! ToggleUVMTags call ToggleUVMTags()
function ToggleUVMTags()
  if g:uvm_tags_is_on
    exe 'set tags-=' . g:uvm_tags_path
  else
    exe 'set tags+=' . g:uvm_tags_path
  endif
  let g:uvm_tags_is_on = !g:uvm_tags_is_on
  echo "UVM tags = " . g:uvm_tags_is_on
endfunction
