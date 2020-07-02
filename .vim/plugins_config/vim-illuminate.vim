autocmd SourcePost illuminate.vim call s:FasterAutocmd()

function s:FasterAutocmd() abort
  let g:Illuminate_delay = 0
  augroup illuminated_autocmd
    autocmd!
    autocmd CursorHold,InsertLeave * call illuminate#on_cursor_moved()
    autocmd WinLeave,BufLeave * call illuminate#on_leaving_autocmds()
    autocmd CursorMovedI * call illuminate#on_cursor_moved_i()
    autocmd InsertEnter * call illuminate#on_insert_entered()
  augroup END
endfunction
