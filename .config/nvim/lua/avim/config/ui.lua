-- don't use treesitter <CR> remap in the command window
vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<CR>', '<CR>', opts)
  end,
})

-- set the syntax to get highlighting in the command window (q: and friends)
vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '[:>]',
  desc = 'If the treesitter vim parser is installed, set the syntax again to get highlighting in the command window',
  group = vim.api.nvim_create_augroup('cmdwin_syntax', {}),
  callback = function()
    local is_loadable, _ = pcall(vim.treesitter.language.add, 'vim')
    if is_loadable then
      vim.cmd('set syntax=vim')
    end
  end
})

require("ui").setup({
  popupmenu = {
    enable = false,
  },
  cmdline = {
    enable = true,
    row_offset = 0,
  },
  message = {
    enable = true,
    history_preference = "ui",
    max_duration = 5000,
    ignore = function(kind, content)
      return kind == "search_cmd"
    end
  }
})
