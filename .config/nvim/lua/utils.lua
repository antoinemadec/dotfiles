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

function _G.string.split (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
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
-- mappings
-- ------------------------------------------------------------
_G.MUtils = {}

function _G.MUtils.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.MUtils.remap_arrow_hjkl(mode, lhs, rhs, opt)
  local arrow_hjkl_table = {Left='h', Down='j', Up='k', Right='l'}
  -- arrow mapping
  vim.api.nvim_set_keymap(mode, lhs, rhs, opt)
  -- hjkl mapping
  for arrow,hjkl in pairs(arrow_hjkl_table) do
    if string.find(lhs, arrow) then
      vim.api.nvim_set_keymap(mode, string.gsub(lhs, arrow, hjkl), rhs, opt)
      return
    end
  end
end

