local a = vim.api

---------------------------------------------------------------
-- general
---------------------------------------------------------------
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

function _G.table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local clock = os.clock
function _G.sleep(n)
  local t0 = clock()
  while clock() - t0 <= n do end
end

---------------------------------------------------------------
-- window
---------------------------------------------------------------
_G.WUtils = {}

function _G.WUtils.save_win_opts(win)
  local win_opts = {}
  for opt, dict in pairs(a.nvim_get_all_options_info()) do
    if dict['scope'] == 'win' then
      win_opts[opt] = a.nvim_win_get_option(win, opt)
    end
  end
  return win_opts
end

function _G.WUtils.restore_win_opts(win, win_opts)
  for opt, val in pairs(win_opts) do
    pcall(a.nvim_win_set_option, win, opt, val)
  end
end

function _G.WUtils.move_win(src_win, dst_win)
  local src_win_cursor = a.nvim_win_get_cursor(src_win)
  local src_win_opts = _G.WUtils.save_win_opts(src_win)
  local src_buf = a.nvim_win_get_buf(src_win)

  _G.WUtils.restore_win_opts(dst_win, src_win_opts)
  a.nvim_win_set_buf(dst_win, src_buf) -- opening a buffer messes up the window opts
  _G.WUtils.restore_win_opts(dst_win, src_win_opts)
  a.nvim_win_set_cursor(dst_win, src_win_cursor)

  a.nvim_win_close(src_win, true)
end

function _G.WUtils.swap_win(src_win, dst_win)
  local src_win_cursor = a.nvim_win_get_cursor(src_win)
  local src_win_opts = _G.WUtils.save_win_opts(src_win)
  local src_buf = a.nvim_win_get_buf(src_win)
  local dst_win_cursor = a.nvim_win_get_cursor(dst_win)
  local dst_win_opts = _G.WUtils.save_win_opts(dst_win)
  local dst_buf = a.nvim_win_get_buf(dst_win)

  -- src -> dst
  _G.WUtils.restore_win_opts(dst_win, src_win_opts)
  a.nvim_win_set_buf(dst_win, src_buf) -- opening a buffer messes up the window opts
  _G.WUtils.restore_win_opts(dst_win, src_win_opts)
  a.nvim_win_set_cursor(dst_win, src_win_cursor)

  -- dst -> src
  _G.WUtils.restore_win_opts(src_win, dst_win_opts)
  a.nvim_win_set_buf(src_win, dst_buf) -- opening a buffer messes up the window opts
  _G.WUtils.restore_win_opts(src_win, dst_win_opts)
  a.nvim_win_set_cursor(src_win, dst_win_cursor)
end

---@param dest string #String "next" or "prev"
function _G.WUtils.move_win_to_tab(dest)
  local is_next = dest == "next"
  local tabs = a.nvim_list_tabpages()
  local wins = a.nvim_tabpage_list_wins(0)
  local src_tab = a.nvim_tabpage_get_number(0)
  local src_win = a.nvim_get_current_win()
  local first_last_cond = src_tab == (is_next and #tabs or 1)
  local go_tab_cmd = is_next and "tabnext" or "tabprev"
  local new_tab_cmd = is_next and "tab split" or "0tab split"

  if #wins == 1 and first_last_cond then
    return
  end

  local vim_cmds = {}
  if first_last_cond then
    table.insert(vim_cmds, new_tab_cmd)
  else
    table.insert(vim_cmds, go_tab_cmd)
    table.insert(vim_cmds, "sp")
  end
  vim.cmd(table.concat(vim_cmds, " | "))

  _G.WUtils.move_win(src_win, 0)
end

-- cycle 4 windows
--    a(1) | b(2) | c(3) | d(4)
-- into
--    a(1) | b(2)
--    c(3) | d(4)
-- into
--    a(1) | c(2)
--    b(3) | d(4)
function _G.WUtils.quad_win_cycle()
  local windows = a.nvim_tabpage_list_wins(0)
  if #windows ~= 4 then
    vim.notify("windows number is different from 4")
    return
  end

  if not vim.t.quad_win_cycle_idx or vim.t.quad_win_cycle_idx > 2 then
    vim.t.quad_win_cycle_idx = 0
  end

  local cur_win = a.nvim_get_current_win()

  if vim.t.quad_win_cycle_idx == 0 then
    for _, win_handle in ipairs(windows) do
      a.nvim_set_current_win(win_handle)
      vim.cmd("wincmd J")
    end
    for _, i in ipairs({1,3}) do
      a.nvim_set_current_win(windows[i+1])
      vim.cmd("vsplit")
      _G.WUtils.move_win(windows[i], 0)
      if windows[i] == cur_win then
        cur_win = a.nvim_get_current_win()
      end
    end
  end

  if vim.t.quad_win_cycle_idx >= 1 then
    _G.WUtils.swap_win(windows[2], windows[3])
  end

  if vim.t.quad_win_cycle_idx == 2 then
    windows = a.nvim_tabpage_list_wins(0)
    for _, win_handle in ipairs(windows) do
      a.nvim_set_current_win(win_handle)
      vim.cmd("wincmd L")
    end
  end

  a.nvim_set_current_win(cur_win)
  vim.t.quad_win_cycle_idx = vim.t.quad_win_cycle_idx + 1
end

function _G.WUtils.toggle_side_bar(win_name, create_win_func)
  if vim.t[win_name] then
    vim.api.nvim_win_close(vim.t[win_name], true)
    vim.t[win_name] = nil
  else
    create_win_func()
    vim.cmd("wincmd L")
    vim.cmd("vertical resize 40")
    vim.wo.winfixwidth = true
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.t[win_name] = vim.api.nvim_get_current_win()
    vim.cmd("wincmd p")
  end
end

---------------------------------------------------------------
-- mappings
---------------------------------------------------------------
_G.MUtils = {}

function _G.MUtils.t(str)
  return a.nvim_replace_termcodes(str, true, true, true)
end

---------------------------------------------------------------
-- DAP
---------------------------------------------------------------
_G.DUtils = {}

function _G.DUtils.input_args()
  local dap_args = {}
  while true do
    local str = vim.fn.input(string.format("args: (%s) ", table.concat(dap_args, ' ')), '', 'file')
    if str ~= "" then
      table.insert(dap_args, str)
    else
      break
    end
  end
  return dap_args
end

function _G.DUtils.notify_args(dap_args)
  vim.notify(string.format("args: %s", table.concat(dap_args, ' ')),
    'info', { title = "DAP" })
end
