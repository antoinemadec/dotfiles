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
