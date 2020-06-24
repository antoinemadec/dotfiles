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

function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_old_idx = tabpagenr()
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if tabpagenr() == l:tab_old_idx
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


"--------------------------------------------------------------
" mappings
"--------------------------------------------------------------
" copy/paste with mouse select
vmap <LeftRelease> "*ygv

" window movement
if has('terminal') || has('nvim')
  tnoremap <expr> <Esc><Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"
  if has('nvim')
    tnoremap <A-Left>     <C-\><C-N><C-w>h
    tnoremap <A-Down>     <C-\><C-N><C-w>j
    tnoremap <A-Up>       <C-\><C-N><C-w>k
    tnoremap <A-Right>    <C-\><C-N><C-w>l
    tnoremap <A-S-Left>   <C-\><C-N><C-w>H
    tnoremap <A-S-Down>   <C-\><C-N><C-w>J
    tnoremap <A-S-Up>     <C-\><C-N><C-w>K
    tnoremap <A-S-Right>  <C-\><C-N><C-w>L
  else
    tnoremap <A-Left>     <C-w>h
    tnoremap <A-Down>     <C-w>j
    tnoremap <A-Up>       <C-w>k
    tnoremap <A-Right>    <C-w>l
    tnoremap <A-S-Left>   <C-w>H
    tnoremap <A-S-Down>   <C-w>J
    tnoremap <A-S-Up>     <C-w>K
    tnoremap <A-S-Right>  <C-w>L
  endif
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
nnoremap <silent> <C-Down>      <C-e>
nnoremap <silent> <C-Up>        <C-y>
nnoremap <silent> <A-w>         :call WindowDoTile()<CR>

" tab movement
if has('terminal') || has('nvim')
  tnoremap <C-A-Left>           <C-\><C-n>gT
  tnoremap <C-A-Right>          <C-\><C-n>gt
  tnoremap <C-A-S-Left>         <C-\><C-n>:call MoveToPrevTab()<CR>
  tnoremap <C-A-S-Right>        <C-\><C-n>:call MoveToNextTab()<CR>
endif
nnoremap <silent> <C-A-Left>    gT
nnoremap <silent> <C-A-Right>   gt
nnoremap <silent> <C-A-S-Left>  :call MoveToPrevTab()<CR>
nnoremap <silent> <C-A-S-Right> :call MoveToNextTab()<CR>
nnoremap <silent> <C-w><C-t>    :tab split<CR>
nnoremap <silent> <C-w>t        :tab split<CR>

" function keys
nnoremap <silent> <F1>          :call MappingHelp()<CR>
nnoremap <silent> <F3>          :NERDTreeToggle<CR>
nnoremap <silent> <F4>          :TagbarToggle<CR>
nnoremap <silent> <F5>          :exe "HighlightGroupsAddWord " . hg0 . " 1"<CR>
nnoremap <silent> <leader><F5>  :exe "HighlightGroupsClearGroup " . hg0 . " 1"<CR>
nnoremap <silent> <F6>          :exe "HighlightGroupsAddWord " . hg1 . " 1"<CR>
nnoremap <silent> <leader><F6>  :exe "HighlightGroupsClearGroup " . hg1 . " 1"<CR>
nnoremap <silent> <F7>          :call ToggleTrailingSpace()<CR>
noremap  <silent> <F8>          :call asyncrun#quickfix_toggle(8)<CR>
nnoremap <silent> <F9>          :set spell!<CR>
inoremap <silent> <F9>    <C-o> :set spell!<CR>
nnoremap <silent> <F10>         :ToggleCompletion<CR>
inoremap <silent> <F10>   <C-o> :ToggleCompletion<CR>
set pastetoggle=<F12>

" leader (inspired by Janus)
if has('terminal') || has('nvim')
  tnoremap <script> <leader>be  <C-\><C-N>:Buffers<CR>
  tnoremap <leader>cd           vim_server_cmd "cd $PWD" -i<CR>
  if  has('nvim')
    tnoremap <leader>ew         nvr .<CR>
    tnoremap <leader>es         nvr -o .<CR>
    tnoremap <leader>ev         nvr -O .<CR>
    tnoremap <leader>et         nvr -p .<CR>
  elseif has('terminal')
    tnoremap vvim               vim_server_open
    tnoremap <leader>ew         vim_server_open .<CR>
    tnoremap <leader>es         vim_server_open . -o<CR>
    tnoremap <leader>ev         vim_server_open . -O<CR>
    tnoremap <leader>et         vim_server_open . -p<CR>
  endif
endif
nnoremap <script> <leader>be    :Buffers<CR>
nnoremap <silent> <leader>ew    :e `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>es    :sp `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>ev    :vsp `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>et    :tabe `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>cd    :cd `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>/     :BLines<CR>
nnoremap <silent> <leader>\     :Commands<CR>
nnoremap <silent> <leader>f     :Files<CR>
nnoremap <silent> <leader>g     :GitFiles<CR>
nnoremap <silent> <leader>ag    :Ag<CR>
nnoremap <silent> <leader>s     :call ToggleGstatus()<CR>
nnoremap <silent> <leader>cv    :Gdiffsplit<CR>
nnoremap <silent> <leader>cn    :Gblame<CR>
if has('terminal') || has('nvim')
  nnoremap <leader>tw :cd `=GetCurrentBufferDir()`<CR>:T<CR><C-\><C-n>:cd -<CR>i
  nnoremap <leader>ts :cd `=GetCurrentBufferDir()`<CR>:TS<CR><C-\><C-n>:cd -<CR>i
  nnoremap <leader>tv :cd `=GetCurrentBufferDir()`<CR>:TV<CR><C-\><C-n>:cd -<CR>i
  nnoremap <leader>tt :cd `=GetCurrentBufferDir()`<CR>:TT<CR><C-\><C-n>:cd -<CR>i
endif

" run/make
nnoremap <silent> <leader>r                       :RunCurrentBuffer<CR>
nnoremap <silent> <leader>t                       :RunAndTimeCurrentBuffer<CR>
autocmd FileType java nnoremap <buffer> <leader>r :RunJavaCurrentBuffer<CR>

" misc
" -- cscope: find functions calling this function
map <C-\> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
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
