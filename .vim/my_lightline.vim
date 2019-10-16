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
  \             [ 'version_control' ],
  \             ['neomake_warnings', 'neomake_errors'] ],
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
  \   'neomake_warnings': 'lightline#neomake#warnings',
  \   'neomake_errors': 'lightline#neomake#errors',
  \   'detecttrailingspace': 'DetectTrailingSpace'
  \ },
  \ 'component_type': {
  \   'foldinfo': 'middle',
  \   'neomake_warnings': 'warning',
  \   'neomake_errors': 'error',
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

if has('job') || has('nvim')
  autocmd BufEnter,BufWinEnter,BufWritePost * call UpdateRevStatus()
else
  autocmd BufWinEnter,BufWritePost * call UpdateRevStatus()
endif
function! UpdateRevStatus()
  let l:vc_cmd = expand('~/.vim/script/version_control_status ' . expand('%:p')) . ' ' . bufnr("%")
  if has('job')
    let l:job = job_start(l:vc_cmd, {"out_cb": "UpdateRevStatusOutCb", "exit_cb": "UpdateRevStatusExitCb"})
  elseif has('nvim')
    let l:job = jobstart(l:vc_cmd, {"on_stdout": "UpdateRevStatusOutCb", "on_exit": "UpdateRevStatusExitCb"})
  else
    let stdout_list = split(system(l:vc_cmd))
    if v:shell_error
      let b:lightline_version_control = 'error'
    elseif len(stdout_list) == 3
      let b:lightline_version_control = join(stdout_list[1:2])
    endif
    call lightline#update()
  endif
endfunction

function! UpdateRevStatusOutCb(ch, stdout, ...)
  let stdl = type(a:stdout) == 3 ? a:stdout : split(a:stdout)
  let stdout_list = has('nvim') ? split(stdl[0]) : stdl
  if len(stdout_list) == 3
    let bufnr  = stdout_list[0]
    let status = join(stdout_list[1:2])
    call setbufvar(bufnr + 0, 'lightline_version_control', status)
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
  if &buftype != 'terminal' && mode() == 'n'
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
