vim.g.tagbar_width = 30
vim.g.tagbar_ctags_bin = 'uctags'
vim.g.tagbar_sort=0

vim.g.tagbar_no_status_line = 1

vim.g.tagbar_stl_verilog_systemverilog = true

-- these keymaps will jump to the next/prev tag regardless of type, and will
-- also use the jump_offset configuration to position the cursor
vim.keymap.set('n', ']t', ':call tagbar#jumpToNearbyTag(1, "nearest", "s")<cr>', {silent=true})
vim.keymap.set('n', '[t', ':call tagbar#jumpToNearbyTag(-1, "nearest", "s")<cr>', {silent=true})
