aug CSV_Editing
  au!
  au BufRead,BufWritePost *.csv :%ArrangeColumn
  au BufWritePre *.csv :%UnArrangeColumn
aug end
