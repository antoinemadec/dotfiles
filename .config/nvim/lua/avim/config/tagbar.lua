vim.g.tagbar_width = 30
vim.g.tagbar_ctags_bin = 'uctags'
vim.g.tagbar_sort=0

-- consider each line to be about 128 bytes
vim.g.tagbar_file_size_limit = vim.g.large_file_cutoff * 128
vim.g.tagbar_no_autocmds = 0
vim.g.tagbar_no_status_line = 1

vim.g.tagbar_stl_verilog_systemverilog = true

local M = {}

function M.stl_is_enabled()
  return vim.g['tagbar_stl_' .. vim.bo.filetype] ~= nil
end

function M.toggle()
  local ok, is_open = pcall(vim.fn['tagbar#IsOpen'])
  vim.t.tagbar_is_open = ok and is_open == 1
  vim.cmd("TagbarToggle")
  vim.t.tagbar_is_open = not vim.t.tagbar_is_open
end

local function tagbar_update()
  -- statusline
  if (not M.stl_is_enabled()) or _G.is_large_file() then
    vim.b.stl_current_tag = ""
  else
    local tag_type = vim.fn['tagbar#currenttagtype']('[%s]', '')
    local tag_name = vim.fn['tagbar#currenttag'](' %s', '')
    vim.b.stl_current_tag =  tag_type .. tag_name
  end
  -- side bar
  if vim.t.tagbar_is_open and not _G.is_large_file() then
    vim.fn['tagbar#Update']()
  end
  -- lualine bug with CursorHold, see:
  -- https://github.com/nvim-lualine/lualine.nvim/issues/886
  vim.cmd('redrawstatus')
end

local function tagbar_autoclose()
  -- automatically close tagbar if it's the only window
  if vim.t.tagbar_is_open then
    if vim.fn['winnr']('$') == 1 then
      vim.cmd("q")
    end
  end
end

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
  pattern = "*",
  callback = tagbar_update,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = function() pcall(vim.fn['tagbar#StopAutoUpdate']) end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "__Tagbar__*",
  callback = tagbar_autoclose,
})

return M
