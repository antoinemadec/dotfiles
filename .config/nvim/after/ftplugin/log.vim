autocmd WinEnter,VimEnter * call MatchUpdate('uvm_info',
      \ 'logLevelTrace', '^UVM_INFO', 11)
autocmd WinEnter,VimEnter * call MatchUpdate('uvm_warning',
      \ 'logLevelWarning', '^UVM_WARNING', 11)
autocmd WinEnter,VimEnter * call MatchUpdate('uvm_error',
      \ 'logLevelError', '^UVM_ERROR\|^UVM_FATAL', 11)
