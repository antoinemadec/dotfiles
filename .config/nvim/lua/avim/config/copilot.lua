vim.cmd([[
imap <silent><script><expr> <M-Tab> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
]])

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { "*" },
  callback = function(_)
    if _G.is_large_file() then
      vim.b.copilot_enabled = false
    else
      vim.b.copilot_enabled = true
    end
  end
})

require("CopilotChat").setup {}
