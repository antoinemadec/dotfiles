autocmd VimEnter * if get(g:, 'launch_debugger', 0) | call timer_start(500, 'StartDebugger') | endif

function StartDebugger(...) abort
  call vimspector#Launch()
  tabo
  nmap <CR> <Plug>VimspectorToggleBreakpoint
endfunction

" calls vim_debugger which:
"   1. unset all VIM env variables
"   2. calls gvim since vimspector works better like that
"   3. sets g:launch_debugger=1 to finally launch vimspector#Launch()
function Debugger()
  let cmd = printf("vim_debugger %s %s", getcwd(), expand("%"))
  exe "Run " . cmd
endfunction
