vim.cmd([[
imap <silent><script><expr> <M-Tab> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
]])
