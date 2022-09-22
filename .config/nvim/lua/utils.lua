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

function _G.save_win_opts()
  local win_opts = {}
  for opt, dict in pairs(vim.api.nvim_get_all_options_info()) do
    if dict['scope'] == 'win' then
      win_opts[opt] = vim.api.nvim_win_get_option(0, opt)
    end
  end
  return win_opts
end

function _G.restore_win_opts(win_opts)
  for opt, val in pairs(win_opts) do
    vim.api.nvim_win_set_option(0, opt, val)
  end
end

---@param dest string #String "next" or "prev"
function _G.move_win_to_tab(dest)
  local is_next = dest == "next"
  local tabs = vim.api.nvim_list_tabpages()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local src_tab = vim.api.nvim_tabpage_get_number(0)
  local src_win = vim.api.nvim_get_current_win()
  local src_buf = vim.api.nvim_get_current_buf()
  local src_cursor = vim.api.nvim_win_get_cursor(0)
  local first_last_cond = src_tab == (is_next and #tabs or 1)
  local go_tab_cmd = is_next and "tabnext" or "tabprev"
  local new_tab_cmd = is_next and "tabnew" or "0tabnew"

  if #wins == 1 and first_last_cond then
    return
  end

  local src_win_opts = _G.save_win_opts()

  local vim_cmds = {}
  if first_last_cond then
    table.insert(vim_cmds, new_tab_cmd)
  else
    table.insert(vim_cmds, go_tab_cmd)
    table.insert(vim_cmds, "sp")
  end
  vim.cmd(table.concat(vim_cmds, " | "))

  -- TODO: try to move the window instead (see CTRL-W_L)
  _G.restore_win_opts(src_win_opts)
  vim.api.nvim_win_set_buf(0, src_buf) -- opening a buffer messes up the window opts
  _G.restore_win_opts(src_win_opts)
  vim.api.nvim_win_set_cursor(0, src_cursor)

  vim.api.nvim_win_close(src_win, true)
end

-- ------------------------------------------------------------
-- mappings
-- ------------------------------------------------------------
_G.MUtils = {}

function _G.MUtils.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
