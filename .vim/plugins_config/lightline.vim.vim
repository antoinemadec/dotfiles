if v:version >= 704
  autocmd TextChanged,InsertLeave * call lightline#update()
  autocmd User CocStatusChange,CocDiagnosticChange if (getfsize(@%) <= g:coc_max_file_size) | call lightline#update() | endif
else
  autocmd InsertLeave * call lightline#update()
endif

autocmd VimEnter * call SetupLightlineColors()
function SetupLightlineColors() abort
  let l:palette = lightline#palette()
  let l:color = l:palette.normal.left[1]
  let l:palette.inactive.right = [l:color]
  let l:palette.inactive.middle = [l:color]
  let l:palette.inactive.left = [l:color]
  call lightline#colorscheme()
endfunction
highlight StatusLineNC cterm=reverse ctermfg=239 ctermbg=223 gui=reverse guifg=#504945 guibg=#ebdbb1

let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'foldinfo', 'mode', 'paste' ],
  \             [ 'readonly', 'myrelativepath', 'mymodified' ],
  \             [ 'version_control' ],
  \             ['mycocstatus'] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percentwin' ],
  \              [ 'spell', 'filetype' ],
  \              [ 'detecttrailingspace' ] ]
  \ },
  \ 'inactive' : {
  \   'left': [ [ 'filename', 'mymodified' ] ],
  \   'right': [ [ '' ] ]
  \ },
  \ 'component_function': {
  \   'readonly': 'MyReadonly',
  \   'filetype': 'MyFiletype',
  \   'mymodified': 'MyModified',
  \   'version_control': 'LightlineVersionControl'
  \ },
  \ 'component_expand': {
  \   'myrelativepath': 'MyRelativePath',
  \   'foldinfo': 'FoldInfo',
  \   'mycocstatus': 'MyCocStatus',
  \   'detecttrailingspace': 'DetectTrailingSpace'
  \ },
  \ 'component_type': {
  \   'foldinfo': 'middle',
  \   'mycocstatus': 'warning',
  \   'detecttrailingspace': 'error'
  \ },
  \ 'tab' : {
  \   'active': [ 'tabnum', 'mytabname', 'modified' ],
  \   'inactive': [ 'tabnum', 'mytabname', 'modified' ]
  \ },
  \ 'tab_component_function' : {
  \   'mytabname': 'MyTabname',
  \   'modified': 'lightline#tab#modified',
  \   'readonly': 'lightline#tab#readonly',
  \   'tabnum': 'lightline#tab#tabnum'
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ }

function! MyReadonly()
  return &readonly ? '🔒' : ''
endfunction

function! MyCocStatus()
  let l:status_str = split(coc#status())[0]
  if l:status_str[0] == "W" || l:status_str[0] == "E"
    return l:status_str
  endif
  return ""
endfunction

function! MyRelativePath()
  if &buftype == 'quickfix'
    return '%t [%{g:asyncrun_status}] %{w:quickfix_title}'
  else
    let l:path = expand('%<%f')
    let l:sub = substitute(l:path, "^fugitive:.*/", "fugitive:", "")
    if l:sub != l:path
      return l:sub
    else
      return '%<%f'
    endif
  endif
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &ft : 'no ft') : ''
endfunction

function! MyTabname(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let _ = expand('#'.buflist[winnr - 1].':t')
  let tn = gettabvar(a:n, 'tabname')
  return strlen(tn) ? tn : _
endfunction

function! MyModified()
  if &buftype == 'quickfix' || &buftype == 'terminal'
    return ''
  else
    return &modified ? '+' : &modifiable ? '' : '-'
  endif
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
