local function toggle_info()
  local columns = { 'permissions', 'size', 'mtime' }
  local config_columns = require 'oil.config'['columns']
  if vim.b.oil_info then
    for _ = 1, #columns do
      table.remove(config_columns, #config_columns)
    end
    vim.b.oil_info = false
  else
    for _, column in pairs(columns) do
      table.insert(config_columns, column)
    end
    vim.b.oil_info = true
  end
  require("oil.actions").refresh.callback()
end

require("oil").setup({
  default_file_explorer = true,
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  delete_to_trash = true,
  -- See :help oil-actions for a list of all available actions
  keymaps = { ["gi"] = { callback = toggle_info, desc = "toggle extra info", mode = "n" } },
  use_default_keymaps = true,
  view_options = {
    show_hidden = true,
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    is_always_hidden = function(name, bufnr)
      return false
    end,
    sort = {
      -- sort order can be "asc" or "desc"
      -- see :help oil-columns to see which columns are sortable
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  preview = {
    update_on_cursor_moved = false, -- avoid bug with fugitive
  },
})
