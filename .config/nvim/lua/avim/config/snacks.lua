require("snacks").setup({
  indent = {
    animate = { enabled = false },
    enabled = true,
    scope = { hl = "CursorLineNr" },
    filter = function(buf)
      return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == "" and
          vim.bo[buf].filetype ~= "startify"
    end,
  },
  input = { enabled = true },
  notifier = {},
  words = { enabled = true },
})

vim.api.nvim_create_user_command("Notifications",
  function()
    require("snacks").notifier.show_history()
  end, {})
