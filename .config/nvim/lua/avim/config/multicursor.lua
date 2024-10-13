local mc = require("multicursor-nvim")

mc.setup()

local set = vim.keymap.set

-- Add or skip cursor above/below the main cursor.
set({ "n", "v" }, "<C-Up>",
  function() mc.lineAddCursor(-1) end)
set({ "n", "v" }, "<C-Down>",
  function() mc.lineAddCursor(1) end)

-- Add or skip adding a new cursor by matching word/selection
set({ "n", "v" }, "<C-n>",
  function() mc.matchAddCursor(1) end)
set({ "n", "v" }, "<C-s>",
  function() mc.matchSkipCursor(1) end)

-- Easy way to add and remove cursors using the main cursor.
set({ "n", "v" }, "<c-q>", mc.toggleCursor)

set("n", "<esc>", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
  else
    -- Default <esc> handler.
  end
end)

-- Append/insert for each line of visual selections.
set("v", "I", mc.insertVisual)
set("v", "A", mc.appendVisual)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { link = "DiffText" })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
