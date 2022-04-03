"--------------------------------------------------------------
" functions
"--------------------------------------------------------------
function MappingHelp()
  if !exists("b:help_scratch_open")
    let l:help_stdout = system("~/.vim/script/custom_mapping_help " . 1)
    let l:stdout_line_count = len(split(l:help_stdout,'\n')) + 1
    exe "Scratch" . l:stdout_line_count . "| 0 put =l:help_stdout | normal gg"
    set ft=docbk
    let b:help_scratch_open = 1
  else
    q
  endif
endfunction

function DirSplit(cmd)
  exe a:cmd . ' ' . GetCurrentBufferDir()
endfunction

function TermSplit(cmd)
  exe 'cd ' . GetCurrentBufferDir()
  exe a:cmd
  cd -
  startinsert
endfunction

function s:map_arrows_and_hjkl(map_str) abort
  exe a:map_str
  let map_str = a:map_str
  let map_str = substitute(map_str, 'Left', 'h', "")
  let map_str = substitute(map_str, 'Right', 'l', "")
  let map_str = substitute(map_str, 'Down', 'j', "")
  let map_str = substitute(map_str, 'Up', 'k', "")
  exe map_str
endfunction


"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
" leader
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" insert movement
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" window movement
if has('terminal')
  tnoremap <expr> <Esc><Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"
    call s:map_arrows_and_hjkl('tnoremap <A-Left>     <C-w>h')
    call s:map_arrows_and_hjkl('tnoremap <A-Down>     <C-w>j')
    call s:map_arrows_and_hjkl('tnoremap <A-Up>       <C-w>k')
    call s:map_arrows_and_hjkl('tnoremap <A-Right>    <C-w>l')
    call s:map_arrows_and_hjkl('tnoremap <A-S-Left>   <C-w>H')
    call s:map_arrows_and_hjkl('tnoremap <A-S-Down>   <C-w>J')
    call s:map_arrows_and_hjkl('tnoremap <A-S-Up>     <C-w>K')
    call s:map_arrows_and_hjkl('tnoremap <A-S-Right>  <C-w>L')
endif
call s:map_arrows_and_hjkl('inoremap <silent> <A-Left>      <C-\><C-N><C-w>h')
call s:map_arrows_and_hjkl('inoremap <silent> <A-Down>      <C-\><C-N><C-w>j')
call s:map_arrows_and_hjkl('inoremap <silent> <A-Up>        <C-\><C-N><C-w>k')
call s:map_arrows_and_hjkl('inoremap <silent> <A-Right>     <C-\><C-N><C-w>l')
call s:map_arrows_and_hjkl('inoremap <silent> <A-S-Left>    <C-\><C-N><C-w>H')
call s:map_arrows_and_hjkl('inoremap <silent> <A-S-Down>    <C-\><C-N><C-w>J')
call s:map_arrows_and_hjkl('inoremap <silent> <A-S-Up>      <C-\><C-N><C-w>K')
call s:map_arrows_and_hjkl('inoremap <silent> <A-S-Right>   <C-\><C-N><C-w>L')
call s:map_arrows_and_hjkl('nnoremap <silent> <A-Left>      <C-w>h')
call s:map_arrows_and_hjkl('nnoremap <silent> <A-Down>      <C-w>j')
call s:map_arrows_and_hjkl('nnoremap <silent> <A-Up>        <C-w>k')
call s:map_arrows_and_hjkl('nnoremap <silent> <A-Right>     <C-w>l')
call s:map_arrows_and_hjkl('nnoremap <silent> <A-S-Left>    <C-w>H')
call s:map_arrows_and_hjkl('nnoremap <silent> <A-S-Down>    <C-w>J')
call s:map_arrows_and_hjkl('nnoremap <silent> <A-S-Up>      <C-w>K')
call s:map_arrows_and_hjkl('nnoremap <silent> <A-S-Right>   <C-w>L')
call s:map_arrows_and_hjkl('nnoremap <silent> <C-Down>      <C-e>')
call s:map_arrows_and_hjkl('nnoremap <silent> <C-Up>        <C-y>')

" tab movement
if has('terminal')
  call s:map_arrows_and_hjkl('tnoremap <C-A-Left>           <C-\><C-n>gT')
  call s:map_arrows_and_hjkl('tnoremap <C-A-Right>          <C-\><C-n>gt')
  call s:map_arrows_and_hjkl('tnoremap <C-A-S-Left>         <C-\><C-n>:call MoveToPrevTab()<CR>')
  call s:map_arrows_and_hjkl('tnoremap <C-A-S-Right>        <C-\><C-n>:call MoveToNextTab()<CR>')
endif
call s:map_arrows_and_hjkl('nnoremap <silent> <C-A-Left>    gT')
call s:map_arrows_and_hjkl('nnoremap <silent> <C-A-Right>   gt')
call s:map_arrows_and_hjkl('nnoremap <silent> <C-A-S-Left>  :call MoveToPrevTab()<CR>')
call s:map_arrows_and_hjkl('nnoremap <silent> <C-A-S-Right> :call MoveToNextTab()<CR>')
nnoremap <silent> <C-w><C-t>    :tab split<CR>
nnoremap <silent> <C-w>t        :tab split<CR>

" function keys
nnoremap <silent> <F1>        :call MappingHelp()<CR>
nnoremap <silent> <F2>        :call Debugger()<CR>
nnoremap <silent> <F3>        :ToggleIndent<CR>
nnoremap <silent> <F4>        :TagbarToggle<CR>
nnoremap <silent> <F5>        :exe "HighlightGroupsAddWord " . hg0 . " 1"<CR>
nnoremap <silent> \<F5>       :exe "HighlightGroupsClearGroup " . hg0 . " 1"<CR>
nnoremap <silent> <F6>        :exe "HighlightGroupsAddWord " . hg1 . " 1"<CR>
nnoremap <silent> \<F6>       :exe "HighlightGroupsClearGroup " . hg1 . " 1"<CR>
nnoremap <silent> <F7>        :call ToggleTrailingSpace()<CR>
noremap  <silent> <F8>        :call asyncrun#quickfix_toggle(8)<CR>
nnoremap <silent> <F9>        :set spell!<CR>
inoremap <silent> <F9>  <C-o> :set spell!<CR>
nnoremap <silent> <F10>       :ToggleCompletion<CR>
inoremap <silent> <F10> <C-o> :ToggleCompletion<CR>
set pastetoggle=<F12>

" git
nmap <silent> [g <Plug>(coc-git-prevchunk)
nmap <silent> ]g <Plug>(coc-git-nextchunk)
omap <silent> ig <Plug>(coc-git-chunk-inner)
xmap <silent> ig <Plug>(coc-git-chunk-inner)
omap <silent> ag <Plug>(coc-git-chunk-outer)
xmap <silent> ag <Plug>(coc-git-chunk-outer)

" space
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
let g:which_key_map = {}
" -- top-level mappings
let g:which_key_map['/'] = [ ':BLines', 'search in file']
let g:which_key_map[';'] = [ ':Commands', 'commands']
" -- find file
let g:which_key_map['f'] = {
      \ 'name' : '+find_file',
      \ 'f'    : [':Files',    'all files'],
      \ 'b'    : [':Buffers',  'buffers'],
      \ 'g'    : [':GitFiles', 'git files'],
      \}
" -- find word
let g:which_key_map['w'] = {
      \ 'name' : '+find_word',
      \ 'w'    : [':Ag',    'all words'],
      \ 'g'    : [':GGrep', 'git grep'],
      \}
" -- split file
let g:which_key_map['s'] = {
      \ 'name' : '+split_file',
      \ 's' : ['<C-w>s', 'horizontal'],
      \ 'v' : ['<C-w>v', 'vertical'],
      \ 't' : ['<C-w>t', 'tab split'],
      \ }
" -- split dir
let g:which_key_map['d'] = {
      \ 'name' : '+split_dir',
      \ 'w' : ['DirSplit("e")',    'current window'],
      \ 's' : ['DirSplit("sp")',   'horizontal'],
      \ 'v' : ['DirSplit("vsp")',  'vertical'],
      \ 't' : ['DirSplit("tabe")', 'tab split'],
      \ }
" -- cd in buffer's dir
let g:which_key_map['c'] = {
      \ 'name' : '+cd_current',
      \ 'c' : [ ':cd `=GetCurrentBufferDir()`', 'global cd'],
      \ 'w' : [ ':lcd `=GetCurrentBufferDir()`', 'window cd'],
      \ 't' : [ ':tcd `=GetCurrentBufferDir()`', 'tab cd'],
      \ }
" -- terminal
let g:which_key_map['t'] = {
      \ 'name' : '+terminal',
      \ 'w' : ['TermSplit("T")',  'current window'],
      \ 's' : ['TermSplit("TS")', 'horizontal'],
      \ 'v' : ['TermSplit("TV")', 'vertical'],
      \ 't' : ['TermSplit("TT")', 'tab split'],
      \ }
" -- git
let g:which_key_map['g'] = {
      \ 'name' : '+git',
      \ 's' : ['ToggleGstatus()',           'git status'],
      \ 'd' : [':Gdiffsplit',               'git diff'],
      \ 'b' : [':Git blame',                'git blame'],
      \ 'i' : ['<Plug>(coc-git-chunkinfo)', 'chunk info'],
      \ 'u' : [':CocCommand git.chunkUndo', 'chunk undo'],
      \ 'c' : [':Commits',                  'list git commits'],
      \}
" -- lsp
let g:which_key_map['l'] = {
      \ 'name' : '+lsp',
      \ 'a'    : [':CocFzfList actions',                   'actions'],
      \ 'b'    : [':CocFzfList diagnostics --current-buf', 'buffer diagnostics'],
      \ 'c'    : [':CocFzfList commands',                  'commands'],
      \ 'd'    : [':CocFzfList diagnostics',               'all diagnostics'],
      \ 'e'    : [':CocFzfList extensions',                'extensions'],
      \ 'l'    : [':CocFzfList',                           'lists'],
      \ 'o'    : [':CocFzfList outline',                   'outline'],
      \ 'p'    : [':CocFzfListResume',                     'previous list'],
      \ 's'    : [':CocFzfList symbols',                   'symbols'],
      \ 't'    : [':Tags',                                 'tags'],
      \ 'y'    : [':CocFzfList yank',                      'yank'],
      \}
call which_key#register('<Space>', "g:which_key_map")

" misc
" -- copy/paste with mouse select
vmap <LeftRelease> "*ygv
" -- add '.' support in visual mode
vnoremap <silent> . :<C-w>let cidx = col(".")<CR> :'<,'>call DotAtColumnIndex(cidx)<CR>
" -- search for visually selected text
vnoremap <silent> * :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy/<C-R><C-R>=substitute(
      \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy?<C-R><C-R>=substitute(
      \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gV:call setreg('"', old_reg, old_regtype)<CR>
cmap w!! w !sudo tee > /dev/null %
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap dO :%diffget<CR>:diffupdate<CR>
nmap dP :%diffput<CR>:diffupdate<CR>
if has('terminal')
  tnoremap \cd vim_server_cmd "cd $PWD" -i<CR>
endif
if has('terminal')
  tnoremap vvim vim_server_open
endif
