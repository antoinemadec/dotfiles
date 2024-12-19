local state = {
  win = -1,
  buf = -1,
  namespace = vim.api.nvim_create_namespace('floaterm'),
}
vim.api.nvim_set_hl(state.namespace, 'NormalFloat', { link = 'Normal' })
vim.api.nvim_set_hl(state.namespace, 'FloatBorder', { link = 'Normal' })

local function open_floating_terminal(opts)
  local width = vim.o.columns
  local height = vim.o.lines
  local win_width = math.floor(width * 0.95)
  local win_height = math.floor(height * 0.85)
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  local valid_buf = vim.api.nvim_buf_is_valid(opts.buf)

  local buf = nil
  if valid_buf then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })
  vim.api.nvim_win_set_hl_ns(win, opts.namespace)

  if not valid_buf then
    vim.cmd("terminal")
  end
  vim.cmd("startinsert")

  return { buf = buf, win = win, namespace = opts.namespace }
end

function _G.toggle_floating_terminal()
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
  else
    state = open_floating_terminal(state)
  end
end
