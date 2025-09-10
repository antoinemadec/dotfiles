require("aerial").setup({
  filter_kind = false, -- show all symbols
  disable_max_lines = vim.g.large_file_cutoff,
  backends = { "treesitter", "markdown", "asciidoc", "man" },
})

local function aerial_update()
  local aerial_location = require("aerial").get_location(true)
  if aerial_location and #aerial_location >= 1 then
    local leaf = aerial_location[#aerial_location]
    vim.b.aerial_current_function = leaf['icon'] .. leaf['name']
  else
    vim.b.aerial_current_function = nil
  end
end

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
  pattern = "*",
  callback = aerial_update,
})

