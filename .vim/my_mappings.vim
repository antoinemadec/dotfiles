"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
" window movement
if has('terminal')
  tnoremap <Esc><Esc>           <C-\><C-n>
  tnoremap <A-Left>             <C-w>h
  tnoremap <A-Down>             <C-w>j
  tnoremap <A-Up>               <C-w>k
  tnoremap <A-Right>            <C-w>l
  tnoremap <A-S-Left>           <C-w>H
  tnoremap <A-S-Down>           <C-w>J
  tnoremap <A-S-Up>             <C-w>K
  tnoremap <A-S-Right>          <C-w>L
endif
inoremap <silent> <A-Left>      <C-\><C-N><C-w>h
inoremap <silent> <A-Down>      <C-\><C-N><C-w>j
inoremap <silent> <A-Up>        <C-\><C-N><C-w>k
inoremap <silent> <A-Right>     <C-\><C-N><C-w>l
inoremap <silent> <A-S-Left>    <C-\><C-N><C-w>H
inoremap <silent> <A-S-Down>    <C-\><C-N><C-w>J
inoremap <silent> <A-S-Up>      <C-\><C-N><C-w>K
inoremap <silent> <A-S-Right>   <C-\><C-N><C-w>L
nnoremap <silent> <A-Left>      <C-w>h
nnoremap <silent> <A-Down>      <C-w>j
nnoremap <silent> <A-Up>        <C-w>k
nnoremap <silent> <A-Right>     <C-w>l
nnoremap <silent> <A-S-Left>    <C-w>H
nnoremap <silent> <A-S-Down>    <C-w>J
nnoremap <silent> <A-S-Up>      <C-w>K
nnoremap <silent> <A-S-Right>   <C-w>L
" tab movement
if has('terminal')
  tnoremap <C-A-Left>           <C-\><C-n>gT
  tnoremap <C-A-Right>          <C-\><C-n>gt
  tnoremap <C-A-S-Left>         <C-\><C-n>:call MoveToPrevTab()<cr>
  tnoremap <C-A-S-Right>        <C-\><C-n>:call MoveToNextTab()<cr>
endif
nnoremap <silent> <C-A-Left>    gT
nnoremap <silent> <C-A-Right>   gt
nnoremap <silent> <C-A-S-Left>  :call MoveToPrevTab()<cr>
nnoremap <silent> <C-A-S-Right> :call MoveToNextTab()<cr>
" function keys
nnoremap <silent> <F2>          :NERDTreeToggle<CR>
nnoremap <silent> <F3>          :call ToggleListTrailingSpacesDisplay()<CR>
nnoremap <silent> <F4>          :ToggleYCM<CR>
nnoremap <silent> <F5>          :exe "HighlightGroupsAddWord " . hg0 . " 0"<CR>
nnoremap <silent> <F6>          :exe "HighlightGroupsAddWord " . hg1 . " 0"<CR>
nnoremap <silent> <S-F5>        :exe "HighlightGroupsClearGroup " . hg0 . " 0"<CR>
nnoremap <silent> <S-F6>        :exe "HighlightGroupsClearGroup " . hg1 . " 0"<CR>
nnoremap <silent> <C-F5>        :exe "HighlightGroupsAddWord " . hg0 . " 1"<CR>
nnoremap <silent> <C-F6>        :exe "HighlightGroupsAddWord " . hg1 . " 1"<CR>
nnoremap <silent> <C-S-F5>      :exe "HighlightGroupsClearGroup " . hg0 . " 1"<CR>
nnoremap <silent> <C-S-F6>      :exe "HighlightGroupsClearGroup " . hg1 . " 1"<CR>
nnoremap <silent> <F7>          :call ToggleIndent()<CR>
nnoremap <silent> <F8>          :RemoveTrailingSpace<CR>
nnoremap <silent> <F9>          :set spell!<CR>
inoremap <silent> <F9>          <C-o>:set spell!<CR>
noremap <silent> <F10>          :call asyncrun#quickfix_toggle(8)<CR>
set pastetoggle=<F12>
" leader (inspired by Janus)
if has('terminal')
  tnoremap <script> <leader>be  vim_server_cmd 'Buffers'<CR>
  tnoremap <leader>ew           vim_server_open .<CR>
  tnoremap <leader>es           vim_server_open . -o<CR>
  tnoremap <leader>ev           vim_server_open . -O<CR>
  tnoremap <leader>et           vim_server_open . -p<CR>
  tnoremap <leader>vim          vim_server_open
  tnoremap <leader>cd           vim_server_cmd "cd $PWD" -i<CR>
endif
nnoremap <script> <leader>be    :Buffers<CR>
nnoremap <silent> <leader>ew    :e %:h<CR>
nnoremap <silent> <leader>es    :sp %:h<CR>
nnoremap <silent> <leader>ev    :vsp %:h<CR>
nnoremap <silent> <leader>et    :tabe %:h<CR>
nnoremap <silent> <leader>cd    :cd %:h<CR>
nnoremap <silent> <leader>r     :RunCurrentBuffer<CR>
nnoremap <silent> <leader>/     :Lines<CR>
nnoremap <silent> <leader>f     :Files<CR>
" terminal
if has('terminal')
  nnoremap <leader>th :T<CR>
  nnoremap <leader>tt :TT<CR>
  nnoremap <leader>tv :TV<CR>
endif
" misc
"   -- add '.' support in visual mode
vnoremap <silent> . :<C-w>let cidx = col(".")<CR> :'<,'>call DotAtColumnIndex(cidx)<CR>
"   -- search for visually selected text
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
nnoremap <silent> K :call DisplayDoc()<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"--------------------------------------------------------------
" functions
"--------------------------------------------------------------
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
