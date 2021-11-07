function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

require('plugins')
require('options')

vim.cmd([[
" highlight current line
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

au TermOpen * setlocal nonumber norelativenumber

"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
source ~/.vim/my_mappings.vim

"--------------------------------------------------------------
" appearance
"--------------------------------------------------------------
if has('termguicolors') && $TERM_COLORS >= 256
  set termguicolors
  let hg0 = 13
  let hg1 = 17
else
  set t_Co=256 " vim uses 256 colors
  let hg0 = 4
  let hg1 = 6
endif
set background=dark
let g:gruvbox_material_background = 'soft'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_palette = 'mix'
colorscheme gruvbox-material
set fillchars=vert:│,fold:+

"--------------------------------------------------------------
" highlighting
"--------------------------------------------------------------
function ToggleTrailingSpace()
  let l:nr = winnr()
  if &list
    windo set nolist
    highlight CustomHighlight_TrailingSpace NONE
  else
    windo set list
    highlight link CustomHighlight_TrailingSpace Todo
  endif
  exe l:nr . "wincmd w"
endfunction
call ToggleTrailingSpace()

autocmd BufWinEnter * call MatchUpdate('trailingspace',
      \ 'CustomHighlight_TrailingSpace',  '\s\+$', 11)
autocmd InsertEnter * call MatchUpdate('trailingspace',
      \ 'CustomHighlight_TrailingSpace', '\s\+\%#\@<!$', 11)
autocmd InsertLeave * call MatchUpdate('trailingspace',
      \ 'CustomHighlight_TrailingSpace',  '\s\+$', 11)

" highlight non breakable space
set listchars=nbsp:?

" always highlight TBD TODO and FIXME no matter the filetype
highlight link CustomHighlight_Warning Todo
autocmd WinEnter,VimEnter * call MatchUpdate('todo',
      \ 'CustomHighlight_Warning', 'TBD\|TODO\|FIXME', 11)

"--------------------------------------------------------------
" terminal
"--------------------------------------------------------------
command! T terminal
command! TS split | terminal
command! TV vsplit | terminal
command! TT tabe | terminal

"--------------------------------------------------------------
" misc
"--------------------------------------------------------------
function MatchUpdate(id_str, hl, pattern, priority) abort
  call MatchDelete(a:id_str)
  if &filetype != 'which_key'
    call MatchAdd(a:id_str, a:hl, a:pattern, a:priority)
  endif
endfunction

function! GetCurrentBufferDir()
  if exists("b:netrw_browser_active")
    return b:netrw_curdir
  elseif expand('%') == "" || &buftype ==# 'terminal'
    return "."
  else
    return expand('%:h')
  endif
endfunction

command! -nargs=0 RemoveTrailingSpace :let _s=@/ | :%s/\s\+$//e | :let @/=_s | :unlet _s

" open scratch buffer
command! -bar -nargs=? Scratch <args>new | setlocal buftype=nofile bufhidden=hide noswapfile

command! ToggleIndent call ToggleIndent()
function! ToggleIndent()
  if &shiftwidth == 2
    setlocal shiftwidth=4 tabstop=4
    echo "Indent = 4"
  else
    setlocal shiftwidth=2 tabstop=2
    echo "Indent = 2"
  endif
endfunction

" repeat last change at a column index
function! DotAtColumnIndex(cidx)
  let a = a:cidx - 1
  execute "normal " . a . "l."
endfunction

" automate opening quickfix window when text adds to it
autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(8, 1)

" gui/not gui specific options
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ 10
  " simple gvim
  set guioptions-=m "remove menu bar
  set guioptions-=T "remove toolbar
  set guioptions-=r "remove right-hand scroll bar
  set guioptions-=L "remove left-hand scroll bar
  " shift insert
  map  <silent>  <S-Insert>  "+p
  imap <silent>  <S-Insert>  <Esc>"+pa
endif

" windows options
if has('win32') && filereadable($HOME.'\.vim\windows.vim')
  source ~/.vim/windows.vim
endif

" make current window float or create float with empty buffer
function WindowDoFloat(...) abort
  let create       = a:0 >= 1 ? a:1 : 0
  let width_ratio  = a:0 >= 2 ? a:2 : 0.9
  let height_ratio = a:0 >= 3 ? a:3 : 0.6
  let width = float2nr(&columns * width_ratio)
  let height = float2nr(&lines * height_ratio)
  let config = { 'relative': 'editor',
        \ 'row': (&lines - height) / 2,
        \ 'col': (&columns - width) / 2,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \}
  if create
    let is_already_floating = nvim_win_get_config(0).relative != ''
    if !is_already_floating
      let buf = nvim_create_buf(v:false, v:false)
      call nvim_open_win(buf, v:true, config)
    endif
  else
    call nvim_win_set_config(0, config)
  endif
endfunction

" help
function! OpenHelpInCurrentWindow(topic)
  view $VIMRUNTIME/doc/help.txt
  setl filetype=help
  setl buftype=help
  setl nomodifiable
  setl nobuflisted
  exe 'keepjumps help ' . a:topic
endfunction
command -complete=help -nargs=* H call WindowDoFloat(1, 0.6) | call OpenHelpInCurrentWindow(<q-args>)
command -complete=help -nargs=* Ht tab help <args>
]])
