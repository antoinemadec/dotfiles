" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ (g:coc_enabled == 0) ? "\<TAB>" :
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Enhanced <CR> experience
inoremap <silent> <expr> <cr> pumvisible() ? "\<C-y>"
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


"--------------------------------------------------------------
" personal config
"--------------------------------------------------------------
let g:coc_max_file_size = 1000000
let s:coc_is_init = 0
autocmd User CocNvimInit let s:coc_is_init = 1 | call DisableCocIfFileTooBig()
autocmd BufWinEnter * call DisableCocIfFileTooBig()

autocmd FileType verilog_systemverilog let b:coc_pairs_disabled = ["'"]

function DisableCocIfFileTooBig() abort
  if s:coc_is_init && g:coc_enabled && &ft != 'fugitive' &&
        \ getfsize(@%) > g:coc_max_file_size
    call wait(3000, "maparg('<BS>', 'i') != ''")
    call MyCocDisable()
  endif
endfunction

function MyCocDisable() abort
  CocDisable
  let l:coc_bs_imap = maparg('<BS>', 'i')
  if l:coc_bs_imap != ""
    let s:coc_bs_imap = l:coc_bs_imap
    iunmap <BS>
  endif
endfunction

function MyCocEnable() abort
  if exists('s:coc_bs_imap')
    exe 'inoremap <silent><expr> <BS> ' . s:coc_bs_imap
  endif
  CocEnable
  echohl MoreMsg
  echom '[coc.nvim] Enabled'
  echohl None
endfunction

command! ToggleCompletion call ToggleCompletion()
function ToggleCompletion()
  if g:coc_enabled
    call MyCocDisable()
  else
    call MyCocEnable()
  endif
endfunction

let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-marketplace',
      \ 'coc-omni',
      \ 'coc-omnisharp',
      \ 'coc-pairs',
      \ 'coc-prettier',
      \ 'coc-python',
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-vetur',
      \ 'coc-vimlsp'
      \]
