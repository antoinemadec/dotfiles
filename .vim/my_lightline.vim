if v:version >= 704
  autocmd TextChanged,InsertLeave * call lightline#update()
else
  autocmd InsertLeave * call lightline#update()
endif

let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'foldinfo', 'mode', 'paste' ],
  \             [ 'readonly', 'myrelativepath', 'mymodified' ],
  \             [ 'version_control' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percentwin' ],
  \              [ 'spell', 'filetype' ],
  \              [ 'detecttrailingspace' ] ]
  \ },
  \ 'inactive' : {
  \   'left': [ [ 'filename', 'mymodified' ] ],
  \   'right': [ [ 'lineinfo' ] ]
  \ },
  \ 'component_function': {
  \   'mymodified': 'MyModified',
  \   'version_control': 'LightlineVersionControl'
  \ },
  \ 'component_expand': {
  \   'myrelativepath': 'MyRelativePath',
  \   'foldinfo': 'FoldInfo',
  \   'detecttrailingspace': 'DetectTrailingSpace'
  \ },
  \ 'component_type': {
  \   'foldinfo': 'middle',
  \   'detecttrailingspace': 'error'
  \ },
  \ }

function! MyRelativePath()
  if &buftype == 'quickfix'
    return '%t [%{g:asyncrun_status}] %{w:quickfix_title}'
  else
    return '%<%f'
  endif
endfunction

function! MyModified()
  if &buftype == 'quickfix' || &buftype == 'terminal'
    return ''
  else
    return &modified ? '+' : &modifiable ? '' : '-'
endfunction

autocmd BufWinEnter,BufWritePost * call UpdateRevStatus()
function! UpdateRevStatus()
  let l:vc_cmd = expand('~/.vim/script/version_control_status ' . expand('%:p')) . ' ' . winnr()
  if has('job')
    let job = job_start(l:vc_cmd, {"out_cb": "UpdateRevStatusOutCb", "exit_cb": "UpdateRevStatusExitCb"})
  elseif has('nvim')
    let job = jobstart(l:vc_cmd, {"on_stdout": "UpdateRevStatusOutCb", "on_exit": "UpdateRevStatusExitCb"})
  else
    let b:lightline_version_control = system(l:vc_cmd)[2:-2]
    if v:shell_error
      let b:lightline_version_control = 'error'
    endif
    call lightline#update()
  endif
endfunction

function! UpdateRevStatusOutCb(ch, stdout, ...)
  let l:str = type(a:stdout) == 3 ? join(a:stdout):a:stdout
  let l:curwin = winnr()
  let l:cmdwin = l:str[0]
  if l:cmdwin != l:curwin
    exe l:cmdwin . "wincmd w"
    let b:lightline_version_control = l:str[2:]
    exe l:curwin . "wincmd w"
  else
    let b:lightline_version_control = l:str[2:]
  endif
endfunction

function! UpdateRevStatusExitCb(ch, err, ...)
  if a:err
    let b:lightline_version_control = 'error'
  endif
  call lightline#update()
endfunction

function! LightlineVersionControl()
  return exists("b:lightline_version_control") ? b:lightline_version_control : ''
endfunction

function! FoldInfo()
  if &foldenable && &foldcolumn >= 6
    return "lvl" . &foldlevel . repeat(" ", &foldcolumn - 6)
  else
    return ""
  endif
endfunction

function! DetectTrailingSpace()
  if mode() == 'n'
    let save_cursor = getpos('.')
    call cursor(1,1)
    let search_result = search("  *$", "c")
    call setpos('.', save_cursor)
    if &list
      return search_result ? "trailing space" : ""
    else
      return "tab & ts hidden"
    endif
  else
    return ""
  endif
endfunction
