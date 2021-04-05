set noshowmode " do not show insert when in insert mode

if v:version >= 704
  autocmd TextChanged,InsertLeave * call lightline#update()
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
else
  autocmd InsertLeave * call lightline#update()
endif

let g:lightline = {
  \ 'colorscheme': 'my_gruvbox',
  \ 'active': {
  \   'left': [['foldinfo', 'mymode', 'paste'],
  \             ['readonly', 'myrelativepath', 'mymodified'],
  \             ['version_control'],
  \             ['mycocstatuserror', 'mycocstatuswarning', 'mycocinfo', 'mycocfunc']],
  \   'right': [['lineinfo'],
  \              ['percentwin'],
  \              ['spell', 'filetype'],
  \              ['detecttrailingspace']]
  \ },
  \ 'inactive' : {
  \   'left': [['filename', 'mymodified']],
  \   'right': [['']]
  \ },
  \ 'component_function': {
  \   'mymode': 'MyMode',
  \   'readonly': 'MyReadonly',
  \   'filetype': 'MyFiletype',
  \   'mymodified': 'MyModified',
  \   'mycocinfo': 'MyCocInfo',
  \   'mycocfunc': 'MyCocFunc',
  \   'version_control': 'MyVersionControl'
  \ },
  \ 'component_expand': {
  \   'myrelativepath': 'MyRelativePath',
  \   'foldinfo': 'MyFoldInfo',
  \   'mycocstatuserror': 'MyCocStatusError',
  \   'mycocstatuswarning': 'MyCocStatusWarning',
  \   'detecttrailingspace': 'MyDetectTrailingSpace'
  \ },
  \ 'component_type': {
  \   'foldinfo': 'middle',
  \   'mycocstatuserror': 'error',
  \   'mycocstatuswarning': 'warning',
  \   'detecttrailingspace': 'warning'
  \ },
  \ 'tab' : {
  \   'active': ['mytabname', 'modified'],
  \   'inactive': ['mytabname', 'modified']
  \ },
  \ 'tab_component_function' : {
  \   'mytabname': 'MyTabname',
  \   'modified': 'lightline#tab#modified',
  \   'readonly': 'lightline#tab#readonly',
  \   'tabnum': 'lightline#tab#tabnum'
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ }

let s:prev_llm = ''
let g:VM_is_active = 0

function MyMode() abort
  if !g:VM_is_active && mode() == s:prev_llm
    return lightline#mode()
  endif
  if !g:VM_is_active
    if mode() == 'n'
      set noshowcmd
    else
      set showcmd
    endif
    let s:prev_llm = mode()
    return lightline#mode()
  else
    let v = b:VM_Selection.Vars
    let vm = VMInfos()
    try
      if v.insert
        if b:VM_Selection.Insert.replace
          let mode = 'V-R'
        else
          let mode = 'V-I'
        endif
      else
        let mode = { 'n': 'V-M', 'v': 'V', 'V': 'V-L', "\<C-v>": 'V-B' }[mode()]
      endif
    catch
      let mode = 'V-M'
    endtry
    let mode = exists('v.statusline_mode') ? v.statusline_mode : mode
    return printf("%s %s", mode, substitute(vm.ratio, ' ', '', 'g'))
  endif
endfunction

function! MyReadonly()
  return &readonly ? '🔒' : ''
endfunction

function! MyCocInfo()
  return winwidth(0) > 100 ? trim(get(g:, 'coc_status', '')) : ''
endfunction

function! MyCocFunc()
  return winwidth(0) > 100 ? get(b:, 'coc_current_function', '') : ''
endfunction

let s:error_sign = get(g:, 'coc_status_error_sign', has('mac') ? '❌ ' : 'E')
let s:warning_sign = get(g:, 'coc_status_warning_sign', has('mac') ? '⚠️ ' : 'W')

function! MyCocStatusError()
  let info = get(b:, 'coc_diagnostic_info', {})
  if get(info, 'error', 0)
    return s:error_sign . info['error']
  endif
  return ''
endfunction

function! MyCocStatusWarning()
  let info = get(b:, 'coc_diagnostic_info', {})
  if get(info, 'warning', 0)
    return s:warning_sign . info['warning']
  endif
  return ''
endfunction

function! MyRelativePath()
  if &buftype == 'quickfix' && exists('w:quickfix_title')
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
  if exists("b:my_file_type") && b:my_file_type['ft'] == &ft
    return winwidth(0) > 70 ? b:my_file_type['str'] : ''
  endif
  let b:my_file_type = {}
  let l:val =  strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &ft : 'no ft'
  let b:my_file_type['str'] = substitute(l:val, 'verilog_systemverilog', 'sv', '')
  let b:my_file_type['ft'] = &ft
  call MyFiletype()
endfunction

function! MyTabname(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let _ = expand('#'.buflist[winnr - 1].':t')
  let tn = gettabvar(a:n, 'tabname')
  return strlen(tn) ? tn : _
endfunction

function! MyModified()
  if &buftype != 'quickfix' && &buftype != 'terminal'
    return &modified ? '+' : &modifiable ? '' : '-'
  else
    return ''
  endif
endfunction

if has('job') || has('nvim')
  autocmd BufEnter,BufWinEnter,BufWritePost * call s:UpdateRevStatus()
else
  autocmd BufWinEnter,BufWritePost * call s:UpdateRevStatus()
endif
function! s:UpdateRevStatus()
  let l:vc_cmd = expand('~/.vim/script/version_control_status ' . expand('%:p')) . ' ' . bufnr("%")
  if has('job')
    let l:job = job_start(l:vc_cmd, {'out_cb': function('s:UpdateRevStatusOutCb'), 'exit_cb': function('s:UpdateRevStatusExitCb')})
  elseif has('nvim')
    let l:job = jobstart(l:vc_cmd, {'on_stdout': function('s:UpdateRevStatusOutCb'), 'on_exit': function('s:UpdateRevStatusExitCb')})
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

function! s:UpdateRevStatusOutCb(ch, stdout, ...)
  let stdl = type(a:stdout) == 3 ? a:stdout : split(a:stdout)
  let stdout_list = has('nvim') ? split(stdl[0]) : stdl
  if len(stdout_list) == 3
    let bufnr  = stdout_list[0]
    let status = join(stdout_list[1:2])
    call setbufvar(bufnr + 0, 'lightline_version_control', status)
  endif
endfunction

function! s:UpdateRevStatusExitCb(ch, err, ...)
  if a:err
    let b:lightline_version_control = 'error'
  endif
  call lightline#update()
endfunction

function! MyVersionControl()
  return exists("b:lightline_version_control") ? b:lightline_version_control : ''
endfunction

function! MyFoldInfo()
  if &foldenable && &foldcolumn >= 6
    return "lvl" . &foldlevel . repeat(" ", &foldcolumn - 6)
  else
    return ""
  endif
endfunction

function! MyDetectTrailingSpace()
  if winwidth(0) > 100 && &ft != 'help' && &ft != 'startify' && &buftype != 'terminal' && mode() == 'n'
    let save_cursor = getpos('.')
    call cursor(1,1)
    let search_result = search("  *$", "c")
    call setpos('.', save_cursor)
    if &list
      return search_result ? "t.space" : ""
    else
      return "tab & ts hidden"
    endif
  else
    return ""
  endif
endfunction
