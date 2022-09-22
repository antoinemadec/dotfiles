" open quickfix window automatically
let g:asyncrun_open = 8

command! -nargs=* -complete=shellcmd Run AsyncRun <args>
command! -nargs=0 RunCurrentBuffer :w | execute("Run " . expand('%:p'))
command! -nargs=0 RunAndTimeCurrentBuffer :w | execute("Run time(" . expand('%:p') . ")")
command! -nargs=0 RunJavaCurrentBuffer :w | execute("Run javac " . expand('%:t') .
      \ " && java " . expand('%:r') )
command! -bang -nargs=* -complete=file Grep AsyncRun -program=grep @ <args>
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
