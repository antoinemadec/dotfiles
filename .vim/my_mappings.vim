" window movement
if has('terminal') || has('nvim')
  tnoremap <Esc><Esc> <C-\><C-n>
  if has('nvim')
    tnoremap <A-Left>  <C-\><C-N><C-w>h
    tnoremap <A-Down>  <C-\><C-N><C-w>j
    tnoremap <A-Up>    <C-\><C-N><C-w>k
    tnoremap <A-Right> <C-\><C-N><C-w>l
  else
    tnoremap <A-Left>  <C-w>h
    tnoremap <A-Down>  <C-w>j
    tnoremap <A-Up>    <C-w>k
    tnoremap <A-Right> <C-w>l
  endif
endif
inoremap <A-Left>      <C-\><C-N><C-w>h
inoremap <A-Down>      <C-\><C-N><C-w>j
inoremap <A-Up>        <C-\><C-N><C-w>k
inoremap <A-Right>     <C-\><C-N><C-w>l
inoremap <A-S-Left>    <C-\><C-N><C-w>H
inoremap <A-S-Down>    <C-\><C-N><C-w>J
inoremap <A-S-Up>      <C-\><C-N><C-w>K
inoremap <A-S-Right>   <C-\><C-N><C-w>L
nnoremap <A-Left>      <C-w>h
nnoremap <A-Down>      <C-w>j
nnoremap <A-Up>        <C-w>k
nnoremap <A-Right>     <C-w>l
nnoremap <A-S-Left>    <C-w>H
nnoremap <A-S-Down>    <C-w>J
nnoremap <A-S-Up>      <C-w>K
nnoremap <A-S-Right>   <C-w>L
" tab movement
nnoremap <C-A-Left>    gT
nnoremap <C-A-Right>   gt
nnoremap <C-A-S-Left>  :call MoveToPrevTab()<cr>
nnoremap <C-A-S-Right> :call MoveToNextTab()<cr>
function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc
function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc
" function keys
nmap <F2>                  :NERDTreeToggle<CR>
nnoremap <silent> <F3>     :call ToggleListTrailingSpacesDisplay()<CR>
nnoremap <silent> <F4>     :ToggleYCM<CR>
nnoremap <silent> <F5>     :exe "HighlightGroupsAddWord " . hg0 . " 0"<CR>
nnoremap <silent> <F6>     :exe "HighlightGroupsAddWord " . hg1 . " 0"<CR>
nnoremap <silent> <S-F5>   :exe "HighlightGroupsClearGroup " . hg0 . " 0"<CR>
nnoremap <silent> <S-F6>   :exe "HighlightGroupsClearGroup " . hg1 . " 0"<CR>
nnoremap <silent> <C-F5>   :exe "HighlightGroupsAddWord " . hg0 . " 1"<CR>
nnoremap <silent> <C-F6>   :exe "HighlightGroupsAddWord " . hg1 . " 1"<CR>
nnoremap <silent> <C-S-F5> :exe "HighlightGroupsClearGroup " . hg0 . " 1"<CR>
nnoremap <silent> <C-S-F6> :exe "HighlightGroupsClearGroup " . hg1 . " 1"<CR>
nnoremap <silent> <F7>     :call ToggleIndent()<CR>
nnoremap <silent> <F8>     :RemoveTrailingSpace<CR>
nnoremap <silent> <F9>     :set spell!<CR>
inoremap <silent> <F9>     <C-o>:set spell!<CR>
noremap <F10>              :call asyncrun#quickfix_toggle(8)<CR>
set pastetoggle=<F12>
" leader (inspired by Janus)
nnoremap <script> <silent> <unique> <Leader>be :Buffers<CR>
nnoremap <leader>ew                            :e %:h<CR>
nnoremap <leader>es                            :sp %:h<CR>
nnoremap <leader>ev                            :vsp %:h<CR>
nnoremap <leader>et                            :tabe %:h<CR>
nnoremap <leader>cd                            :cd %:h<CR>
if has('terminal')
  tnoremap <leader>cd                          cdvim<CR>
  tnoremap <leader>ew                         vim --servername $VIM_SERVERNAME --remote .<CR>
  tnoremap <leader>es                         vim --servername $VIM_SERVERNAME --remote .<CR>
  tnoremap <leader>ev                         vim --servername $VIM_SERVERNAME --remote .<CR>
  tnoremap <leader>et                         vim --servername $VIM_SERVERNAME --remote .<CR>
endif
nnoremap <leader>r                             :RunCurrentBuffer<CR>
nnoremap <leader>/                             :Lines<CR>
" misc
"   -- add '.' support in visual mode
vnoremap . :<C-w>let cidx = col(".")<CR> :'<,'>call DotAtColumnIndex(cidx)<CR>
cmap w!! w !sudo tee > /dev/null %
nnoremap K :call DisplayDoc()<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
