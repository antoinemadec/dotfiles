vim.keymap.set('i', '<C-CR>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

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
