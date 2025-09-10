require("snacks").setup({
  indent = {
    animate = { enabled = false },
    enabled = true,
    scope = { hl = "CursorLineNr" },
    filter = function(buf) -- what buffers to enable
      return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == "" and
          vim.bo[buf].filetype ~= "startify"
    end,
  },
  words = {
    enabled = true,
    filter = function(buf) -- what buffers to enable
      return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
    end,
  },
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { "*" },
  callback = function(_)
    if _G.is_large_file() then
      vim.b.snacks_indent = false
      vim.b.snacks_words = false
      require("snacks").indent.disable()
      require("snacks").words.disable()
    else
      vim.b.snacks_indent = true
      vim.b.snacks_words = true
      require("snacks").indent.enable()
      require("snacks").words.enable()
    end
  end
})
