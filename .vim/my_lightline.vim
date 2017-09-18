if v:version >= 704
  autocmd TextChanged,InsertLeave * call lightline#update()
else
  autocmd InsertLeave * call lightline#update()
endif
let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'foldinfo', 'mode', 'paste' ],
  \             [ 'readonly', 'relativepath', 'modified' ],
  \             [ 'fugitive' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percentwin' ],
  \              [ 'spell', 'filetype' ],
  \              [ 'detecttrailingspace' ] ]
  \ },
  \ 'inactive' : {
  \   'left': [ [ 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ] ]
  \ },
  \ 'component_function': {
  \   'fugitive': 'LightlineFugitive'
  \ },
  \ 'component_expand': {
  \   'foldinfo': 'FoldInfo',
  \   'detecttrailingspace': 'DetectTrailingSpace'
  \ },
  \ 'component_type': {
  \   'foldinfo': 'middle',
  \   'detecttrailingspace': 'error'
  \ },
  \ }

autocmd BufEnter,BufWinEnter,BufWritePost * call UpdateGitStatus()
function! UpdateGitStatus()
  let b:GitStatus = ''
  if exists('*fugitive#head')
    let branch = fugitive#head()
    if branch != ''
      let l:filename  = expand('%:t')
      let l:dirname   = expand('%:h')
      let l:gitcmd    = 'git -C ' . l:dirname . ' status --porcelain ' . l:filename
      let b:GitStatus = system(l:gitcmd)
    endif
  endif
endfunction

" copied from NERDTree
let g:NERDTreeIndicatorMap = {
      \ 'Modified'  : '✹',
      \ 'Staged'    : '✚',
      \ 'Untracked' : '✭',
      \ 'Renamed'   : '➜',
      \ 'Unmerged'  : '═',
      \ 'Deleted'   : '✖',
      \ 'Dirty'     : '✗',
      \ 'Clean'     : '✔︎',
      \ 'Ignored'   : '☒',
      \ 'Unknown'   : '?'
      \ }
function! LightlineFugitive()
  let b:lightline_fugitive = ''
  if exists('*fugitive#head') && exists("b:GitStatus") && (match(b:GitStatus, "fatal:") == -1)
    let branch = fugitive#head()
    if branch != ''
      let l:statusKey = GetFileGitStatusKey(b:GitStatus[0], b:GitStatus[1])
      let l:indicator = get(g:NERDTreeIndicatorMap, l:statusKey, '')
      let b:lightline_fugitive = branch . ' ' . l:indicator
    endif
  endif
  return b:lightline_fugitive
endfunction
function! GetFileGitStatusKey(us, them)
    if a:us ==# '?' && a:them ==# '?'
        return 'Untracked'
    elseif a:us ==# ' ' && a:them ==# 'M'
        return 'Modified'
    elseif a:us =~# '[MAC]'
        return 'Staged'
    elseif a:us ==# 'R'
        return 'Renamed'
    elseif a:us ==# 'U' || a:them ==# 'U' || a:us ==# 'A' && a:them ==# 'A' || a:us ==# 'D' && a:them ==# 'D'
        return 'Unmerged'
    elseif a:them ==# 'D'
        return 'Deleted'
    elseif a:us ==# '!'
        return 'Ignored'
    else
        return 'Clean'
    endif
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
    return search_result ? "trailing_space" : ""
  else
    return ""
  endif
endfunction
