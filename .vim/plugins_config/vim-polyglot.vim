aug CSV_Editing
  au!
  au BufRead,BufWritePost *.csv :%ArrangeColumn
  au BufWritePre *.csv :%UnArrangeColumn
aug end

aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
aug end

hi link pythonFunctionCall Identifier
let g:python_highlight_file_headers_as_comments = 1
let g:python_highlight_space_errors = 0
