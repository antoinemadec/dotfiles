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

function _G.is_large_file(bufnr)
  if bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end
  return vim.api.nvim_buf_line_count(bufnr) > vim.g.large_file_cutoff
end

function _G.dim_color(color, dimming_pct)
  local b = bit.band(color, 255)
  local g = bit.band(bit.rshift(color, 8), 255)
  local r = bit.band(bit.rshift(color, 16), 255)
  local b_dim = math.floor((b * dimming_pct) / 100);
  local g_dim = math.floor((g * dimming_pct) / 100);
  local r_dim = math.floor((r * dimming_pct) / 100);
  return bit.lshift(r_dim, 16) + bit.lshift(g_dim, 8) + b_dim
end

---------------------------------------------------------------
-- text
---------------------------------------------------------------
_G.TUtils = {}

-- replace indentation spaces with markdown bullets
function _G.TUtils.indentation_to_bullets(left_mark, right_mark)
  local line_start = vim.fn.getpos(left_mark)[2]
  local line_end = vim.fn.getpos(right_mark)[2]

  local lines = vim.fn.getline(line_start, line_end)

  for i, line in ipairs(lines) do
    local space_count = 0
    for c in line:gmatch('.') do
      if c ~= " " then
        break
      end
      space_count = space_count + 1
    end
    local indent_level = space_count / vim.bo.shiftwidth
    lines[i] = string.rep(" ", indent_level * 2) .. "* " .. line:sub(space_count + 1)
  end

  vim.fn.setline(line_start, lines)
end

function _G.TUtils.indentation_to_bullets_opfunc(type)
  _G.TUtils.indentation_to_bullets("'[", "']")
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

---------------------------------------------------------------
-- LSP
---------------------------------------------------------------
_G.LUtils = {}

_G.LUtils.kind_labels = {
  Array         = " ",
  Boolean       = "󰨙 ",
  Class         = " ",
  Codeium       = "󰘦 ",
  Color         = " ",
  Control       = " ",
  Collapsed     = " ",
  Constant      = "󰏿 ",
  Constructor   = " ",
  Copilot       = " ",
  Enum          = " ",
  EnumMember    = " ",
  Event         = " ",
  Field         = " ",
  File          = " ",
  Folder        = " ",
  Function      = "󰊕 ",
  Interface     = " ",
  Key           = " ",
  Keyword       = " ",
  Method        = "󰊕 ",
  Module        = " ",
  Namespace     = "󰦮 ",
  Null          = " ",
  Number        = "󰎠 ",
  Object        = " ",
  Operator      = " ",
  Package       = " ",
  Property      = " ",
  Reference     = " ",
  Snippet       = " ",
  String        = " ",
  Struct        = "󰆼 ",
  TabNine       = "󰏚 ",
  Text          = " ",
  TypeParameter = " ",
  Unit          = " ",
  Value         = " ",
  Variable      = "󰀫 ",
}

function _G.LUtils.get_kind_labels(kind)
  return _G.LUtils.kind_labels[kind] or kind
end

function _G.LUtils.format()
  require("conform").format({ lsp_fallback = true, async = true })
end
