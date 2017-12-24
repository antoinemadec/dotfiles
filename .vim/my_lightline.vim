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
  \             [ 'fugitive' ] ],
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
  \   'fugitive': 'LightlineFugitive'
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

autocmd BufWinEnter,BufWritePost * call UpdateGitStatus()
function! UpdateGitStatus()
  if exists('*fugitive#head')
    let b:GitBranch = fugitive#head()
    if b:GitBranch != ''
      let l:filename  = expand('%:t')
      let l:dirname   = expand('%:h')
      let l:gitcmd    = 'cd ' . l:dirname . '; git status --porcelain ' . l:filename
      if has('job')
        let b:GitStatus = ''
        let job = job_start('bash -c "' . l:gitcmd . '"', {"out_cb": "UpdateGitStatusOutCb", "exit_cb": "UpdateGitStatusExitCb"})
      else
        let b:GitStatus = system(l:gitcmd)
        let b:lightline_fugitive = v:shell_error ? '' : b:GitBranch . ' ' . GetFileGitIndicator(b:GitStatus[0], b:GitStatus[1])
        call lightline#update()
      endif
    endif
  endif
endfunction

function! UpdateGitStatusOutCb(ch, stdout)
  let b:GitStatus = a:stdout
endfunction

function! UpdateGitStatusExitCb(ch, err)
  let b:lightline_fugitive = a:err ? '' : b:GitBranch . ' ' . GetFileGitIndicator(b:GitStatus[0], b:GitStatus[1])
  call lightline#update()
endfunction

function! GetFileGitIndicator(us, them)
    if a:us ==# '?' && a:them ==# '?'
        return '✭' " untracked
    elseif a:us ==# ' ' && a:them ==# 'M'
        return '✹' " modified
    elseif a:us =~# '[MAC]'
        return '✚' " staged
    elseif a:us ==# 'R'
        return '➜' " renamed
    elseif a:us ==# 'U' || a:them ==# 'U' || a:us ==# 'A' && a:them ==# 'A' || a:us ==# 'D' && a:them ==# 'D'
        return '═' " unmerged
    elseif a:them ==# 'D'
        return '✖' " deleted
    elseif a:us ==# '!'
        return '☒' " ignored
    else
        return '✔︎' " clean
    endif
endfunction

function! LightlineFugitive()
  return exists("b:lightline_fugitive") ? b:lightline_fugitive : ''
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
