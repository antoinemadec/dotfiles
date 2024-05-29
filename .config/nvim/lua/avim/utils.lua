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

function _G.is_large_file()
  return vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf()) > vim.g.large_file_cutoff
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

-- lsp current function
local scope_kinds = {
  Class = true,
  Function = true,
  Method = true,
  Struct = true,
  Enum = true,
  Interface = true,
  Namespace = true,
  Module = true,
}

local lsp_proto = require('vim.lsp.protocol')

local function filter(list, test)
  local result = {}
  for i, v in ipairs(list) do
    if test(i, v) then
      table.insert(result, v)
    end
  end

  return result
end

local function extract_symbols(items, _result)
  local result = _result or {}
  if items == nil then return result end
  for _, item in ipairs(items) do
    local kind = lsp_proto.SymbolKind[item.kind] or 'Unknown'
    local sym_range = nil
    if item.location then  -- Item is a SymbolInformation
      sym_range = item.location.range
    elseif item.range then -- Item is a DocumentSymbol
      sym_range = item.range
    end

    if sym_range then
      sym_range.start.line = sym_range.start.line + 1
      sym_range['end'].line = sym_range['end'].line + 1
    end

    table.insert(result, {
      filename = item.location and vim.uri_to_fname(item.location.uri) or nil,
      range = sym_range,
      kind = kind,
      text = item.name,
      raw_item = item
    })

    if item.children then
      extract_symbols(item.children, result)
    end
  end

  return result
end

local function in_range(pos, range)
  local line = pos[1]
  local char = pos[2]
  if line < range.start.line or line > range['end'].line then return false end
  if
      line == range.start.line and char < range.start.character or
      line == range['end'].line and char > range['end'].character
  then
    return false
  end

  return true
end

local function current_function_callback(_, result)
  vim.b.lsp_current_function = ''
  if type(result) ~= 'table' then
    return
  end

  local function_symbols = filter(extract_symbols(result),
    function(_, v)
      return scope_kinds[v.kind]
    end)

  if not function_symbols or #function_symbols == 0 then
    return
  end

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  for i = #function_symbols, 1, -1 do
    local sym = function_symbols[i]
    if sym.range and in_range(cursor_pos, sym.range) then
      local fn_name = _G.LUtils.get_kind_labels(sym.kind) .. sym.text
      vim.b.lsp_current_function = fn_name
      return
    end
  end
end

function _G.LUtils.update_current_function()
  local params = { textDocument = { uri = vim.uri_from_bufnr(0) } }
  vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, current_function_callback)
end

function _G.LUtils.format()
  require("conform").format({ lsp_fallback = true, async = true })
end
