"--------------------------------------------------------------
" functions
"--------------------------------------------------------------
function Mapping(idx, ...)
  let l:open_help = get(a:, 1, 1)
  if (a:idx == 1)
    nnoremap <silent> <F1>          :call Mapping(1)<CR>
    inoremap <silent> <F1>    <C-o> :call Mapping(1)<CR>
    nnoremap <silent> <F2>          :call Mapping(2)<CR>
    inoremap <silent> <F2>    <C-o> :call Mapping(2)<CR>
    nnoremap <silent> <F3>          :set spell!<CR>
    inoremap <silent> <F3>    <C-o> :set spell!<CR>
    nnoremap <silent> <F4>          :ToggleCompletion<CR>
    inoremap <silent> <F4>    <C-o> :ToggleCompletion<CR>
    nnoremap <silent> <F5>          :exe "HighlightGroupsAddWord " . hg0 . " 1"<CR>
    nnoremap <silent> <F6>          :exe "HighlightGroupsAddWord " . hg1 . " 1"<CR>
    nnoremap <silent> <leader><F5>  :exe "HighlightGroupsClearGroup " . hg0 . " 1"<CR>
    nnoremap <silent> <leader><F6>  :exe "HighlightGroupsClearGroup " . hg1 . " 1"<CR>
    nnoremap <silent> <F7>          :call ToggleTrailingSpace()<CR>
    noremap  <silent> <F8>          :call asyncrun#quickfix_toggle(8)<CR>
    nnoremap <silent> <F9>          :TagbarToggle<CR>
    nnoremap <silent> <F10>         :NERDTreeToggle<CR>
    set pastetoggle=<F12>
  elseif (a:idx == 2)
    nnoremap <silent> <F1>    :call Mapping(1)<CR>
    inoremap <silent> <F1>    <C-o>:call Mapping(1)<CR>
    nnoremap <silent> <F2>    :call Mapping(2)<CR>
    inoremap <silent> <F2>    <C-o>:call Mapping(2)<CR>
    nnoremap <silent> <F3>    :call ToggleIndent()<CR>
    nnoremap <silent> <F4>    :ToggleUVMTags<CR>
    nnoremap <silent> <F5>    :MacroLoad<CR>
    nnoremap <silent> <F6>    :MacroStore<CR>
    nnoremap <silent> <F7>    :RemoveTrailingSpace<CR>
    nnoremap <silent> <F8>    :NeomakeToggle<CR>
  endif
  if (l:open_help)
    if !exists("b:help_scratch_open") || (b:help_scratch_open != a:idx)
      let l:help_stdout = system("~/.vim/script/custom_mapping_help " . a:idx)
      let l:stdout_line_count = len(split(l:help_stdout,'\n')) + 1
      if exists("b:help_scratch_open") && (b:help_scratch_open != a:idx)
        q
      endif
      exe "Scratch" . l:stdout_line_count . "| 0 put =l:help_stdout | normal gg"
      set ft=docbk
      let b:help_scratch_open = a:idx
    else
      q
    endif
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
" window movement
if has('terminal') || has('nvim')
  tnoremap <Esc><Esc> <C-\><C-n>
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

" tab movement
if has('terminal') || has('nvim')
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
call Mapping(1, 0)

" leader (inspired by Janus)
if has('terminal')
  tnoremap <script> <leader>be  vim_server_cmd 'Buffers'<CR>
  tnoremap <leader>ew           vim_server_open .<CR>
  tnoremap <leader>es           vim_server_open . -o<CR>
  tnoremap <leader>ev           vim_server_open . -O<CR>
  tnoremap <leader>et           vim_server_open . -p<CR>
  tnoremap vvim                 vim_server_open
  tnoremap <leader>cd           vim_server_cmd "cd $PWD" -i<CR>
endif
nnoremap <script> <leader>be    :Buffers<CR>
nnoremap <silent> <leader>ew    :e `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>es    :sp `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>ev    :vsp `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>et    :tabe `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>cd    :cd `=GetCurrentBufferDir()`<CR>
nnoremap <silent> <leader>/     :Lines<CR>
nnoremap <silent> <leader>f     :Files<CR>
nnoremap <silent> <leader>s     :Gstatus<CR>
nnoremap <silent> <leader>cv    :Gdiffsplit<CR>
nnoremap <silent> <leader>cn    :Gblame<CR>
if has('terminal') || has('nvim')
  nnoremap <leader>tw :cd `=GetCurrentBufferDir()`<CR>:T<CR><C-\><C-n>:cd -<CR>i
  nnoremap <leader>ts :cd `=GetCurrentBufferDir()`<CR>:TS<CR><C-\><C-n>:cd -<CR>i
  nnoremap <leader>tv :cd `=GetCurrentBufferDir()`<CR>:TV<CR><C-\><C-n>:cd -<CR>i
  nnoremap <leader>tt :cd `=GetCurrentBufferDir()`<CR>:TT<CR><C-\><C-n>:cd -<CR>i
endif

" completion
" use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
" format the whole file
nmap <leader>P <Plug>(coc-format)
" remap for format selected region
xmap <leader>p  <Plug>(coc-format-selected)
nmap <leader>p  <Plug>(coc-format-selected)
" using coclist
" show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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
