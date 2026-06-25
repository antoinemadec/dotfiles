-- Custom aerial backend for indentation-based outline files (ft=indentcolor),
-- e.g. ~/org/todo_main.txt. The symbol tree mirrors the indentation hierarchy.
local backend_util = require("aerial.backends.util")
local backends = require("aerial.backends")
local config = require("aerial.config")
local util = require("aerial.util")

local M = {}

M.is_supported = function(bufnr)
  if not vim.tbl_contains(util.get_filetypes(bufnr), "indentcolor") then
    return false, "Filetype is not indentcolor"
  end
  return true, nil
end

-- Leading-whitespace width, expanding tabs to the buffer's tabstop.
local function get_indent(line, tabstop)
  local ws = line:match("^%s*")
  local width = 0
  for i = 1, #ws do
    if ws:sub(i, i) == "\t" then
      width = width + tabstop - (width % tabstop)
    else
      width = width + 1
    end
  end
  return width
end

local function get_line_len(bufnr, lnum)
  return vim.api.nvim_strwidth(vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, true)[1])
end

-- A symbol spans down to the line before its next sibling (or the parent's end).
local function set_end_range(bufnr, items, last_line)
  if not items then
    return
  end
  last_line = last_line or vim.api.nvim_buf_line_count(bufnr)
  local prev = nil
  for _, item in ipairs(items) do
    if prev then
      prev.end_lnum = item.lnum - 1
      prev.end_col = get_line_len(bufnr, prev.end_lnum)
      set_end_range(bufnr, prev.children, prev.end_lnum)
    end
    prev = item
  end
  if prev then
    prev.end_lnum = last_line
    prev.end_col = get_line_len(bufnr, last_line)
    set_end_range(bufnr, prev.children, last_line)
  end
end

M.fetch_symbols_sync = function(bufnr)
  bufnr = bufnr or 0
  local tabstop = vim.bo[bufnr].tabstop
  if tabstop == 0 then
    tabstop = 8
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
  local items = {}
  local stack = {} -- entries: { indent = <width>, item = <item> }
  for lnum, line in ipairs(lines) do
    -- Skip blank lines and the vim modeline.
    if line:match("%S") and not line:match("^#%s*vim:") then
      local indent = get_indent(line, tabstop)
      while #stack > 0 and stack[#stack].indent >= indent do
        table.remove(stack)
      end
      local parent = stack[#stack] and stack[#stack].item or nil
      local item = {
        kind = parent == nil and "Struct" or "Field",
        name = vim.trim(line),
        level = #stack,
        parent = parent,
        lnum = lnum,
        col = 0,
      }
      if item.level < 2 then
        if parent then
          parent.children = parent.children or {}
          table.insert(parent.children, item)
        elseif
          not config.post_parse_symbol
          or config.post_parse_symbol(bufnr, item, { backend_name = "indent", lang = "indent" }) ~= false
        then
          table.insert(items, item)
        end
        table.insert(stack, { indent = indent, item = item })
      end
    end
  end
  set_end_range(bufnr, items)
  backends.set_symbols(bufnr, items, { backend_name = "indent", lang = "indent" })
end

M.fetch_symbols = M.fetch_symbols_sync

M.attach = function(bufnr)
  backend_util.add_change_watcher(bufnr, "indent")
end

M.detach = function(bufnr)
  backend_util.remove_change_watcher(bufnr, "indent")
end

return M
