local a = vim.api

-- ------------------------------------------------------------
-- general
-- ------------------------------------------------------------
function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

function _G.string.split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local clock = os.clock
function _G.sleep(n)
  local t0 = clock()
  while clock() - t0 <= n do end
end

-- ------------------------------------------------------------
-- window
-- ------------------------------------------------------------
_G.WUtils = {}

function _G.WUtils.save_win_opts()
  local win_opts = {}
  for opt, dict in pairs(a.nvim_get_all_options_info()) do
    if dict['scope'] == 'win' then
      win_opts[opt] = a.nvim_win_get_option(0, opt)
    end
  end
  return win_opts
end

function _G.WUtils.restore_win_opts(win_opts)
  for opt, val in pairs(win_opts) do
    a.nvim_win_set_option(0, opt, val)
  end
end

---@param dest string #String "next" or "prev"
function _G.WUtils.move_win_to_tab(dest)
  local is_next = dest == "next"
  local tabs = a.nvim_list_tabpages()
  local wins = a.nvim_tabpage_list_wins(0)
  local src_tab = a.nvim_tabpage_get_number(0)
  local src_win = a.nvim_get_current_win()
  local src_buf = a.nvim_get_current_buf()
  local src_cursor = a.nvim_win_get_cursor(0)
  local first_last_cond = src_tab == (is_next and #tabs or 1)
  local go_tab_cmd = is_next and "tabnext" or "tabprev"
  local new_tab_cmd = is_next and "tabnew" or "0tabnew"

  if #wins == 1 and first_last_cond then
    return
  end

  local src_win_opts = _G.WUtils.save_win_opts()

  local vim_cmds = {}
  if first_last_cond then
    table.insert(vim_cmds, new_tab_cmd)
  else
    table.insert(vim_cmds, go_tab_cmd)
    table.insert(vim_cmds, "sp")
  end
  vim.cmd(table.concat(vim_cmds, " | "))

  -- TODO: try to move the window instead (see CTRL-W_L)
  _G.WUtils.restore_win_opts(src_win_opts)
  a.nvim_win_set_buf(0, src_buf) -- opening a buffer messes up the window opts
  _G.WUtils.restore_win_opts(src_win_opts)
  a.nvim_win_set_cursor(0, src_cursor)

  a.nvim_win_close(src_win, true)
end

function _G.WUtils.quad_win_split()
  local windows = a.nvim_tabpage_list_wins(0)

  if #windows ~= 4 then
    vim.notify("windows number is different from 4")
    return
  end

  for _, win_handle in ipairs(windows) do
    a.nvim_set_current_win(win_handle)
    vim.cmd("wincmd L")
  end

  a.nvim_set_current_win(windows[3])
  vim.cmd("sbuffer " .. a.nvim_win_get_buf(windows[1]))
  a.nvim_win_close(windows[1], true)

  a.nvim_set_current_win(windows[4])
  vim.cmd("sbuffer " .. a.nvim_win_get_buf(windows[2]))
  a.nvim_win_close(windows[2], true)

  windows = a.nvim_tabpage_list_wins(0)
  a.nvim_set_current_win(windows[1])
end

-- ------------------------------------------------------------
-- mappings
-- ------------------------------------------------------------
_G.MUtils = {}

function _G.MUtils.t(str)
  return a.nvim_replace_termcodes(str, true, true, true)
end
