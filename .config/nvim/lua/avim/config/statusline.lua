local palette = { bg_yellow = { '#e9b143', '214' }, bg_visual_red = { '#543937', '52' }, bg_visual_blue = { '#404946', '17' }, bg_diff_green = { '#3d4220', '22' }, bg_current_word = { '#45403d', '238' }, fg0 = { '#e2cca9', '223' }, fg1 = { '#e2cca9', '223' }, purple = { '#d3869b', '175' }, grey2 = { '#a89984', '246' }, aqua = { '#8bba7f', '108' }, bg_visual_yellow = { '#574833', '94' }, none = { 'NONE', 'NONE' }, bg_diff_red = { '#472322', '52' }, orange = { '#f28534', '208' }, bg_dim = { '#252423', '233' }, bg_red = { '#db4740', '167' }, bg0 = { '#32302f', '236' }, bg1 = { '#3c3836', '237' }, bg2 = { '#3c3836', '237' }, bg3 = { '#504945', '239' }, bg4 = { '#504945', '239' }, bg5 = { '#665c54', '241' }, grey0 = { '#7c6f64', '243' }, grey1 = { '#928374', '245' }, bg_statusline1 = { '#3c3836', '237' }, bg_statusline2 = { '#46413e', '237' }, bg_statusline3 = { '#5b534d', '241' }, bg_visual_green = { '#424a3e', '22' }, green = { '#b0b846', '142' }, bg_diff_blue = { '#0f3a42', '17' }, bg_green = { '#b0b846', '142' }, blue = { '#80aa9e', '109' }, red = { '#f2594b', '167' }, yellow = { '#e9b143', '214' } }
local a = vim.api

-- statusline
local function get_function_name()
  return vim.b.aerial_current_function or ''
end

local function location_or_selected_lines()
  local pos_l = vim.fn.getpos('.')
  local pos_v = vim.fn.getpos('v')
  local d_line = math.abs(pos_l[2] - pos_v[2]) + 1
  local d_col = math.abs(pos_l[3] - pos_v[3]) + 1
  local s = string.format("<%0d,%0d>", d_line, d_col)
  return (d_line ~= 1 or d_col ~= 1) and s or '%3l:%-2v'
end

local function large_file()
  return _G.is_large_file() and "🛑" or ""
end

local function treesitter_status()
  local buf = vim.api.nvim_get_current_buf()
  return vim.treesitter.highlighter.active[buf] and "🌳" or ""
end

local function searchcount()
  if vim.v.hlsearch == 0 or _G.is_large_file() then
    return ''
  end

  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
  if not ok or next(result) == nil then
    return ''
  end

  local denominator = math.min(result.total, result.maxcount)
  return string.format('[%d/%d]', result.current, denominator)
end

require 'lualine'.setup {
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = 'auto',
    section_separators = '',
    component_separators = '',
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch',
      {
        'diff',
        diff_color = {
          added    = { fg = palette.green[1] },
          modified = { fg = palette.blue[1] },
          removed  = { fg = palette.red[1] },
        },
      },
      {
        get_function_name,
        color = { bg = palette.bg_visual_blue[1] }
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        diagnostics_color = {
          error = { bg = palette.red[1], fg = palette.bg0[1] },
          warn  = { bg = palette.yellow[1], fg = palette.bg0[1] },
          info  = { bg = palette.blue[1], fg = palette.bg0[1] },
          hint  = { bg = palette.purple[1], fg = palette.bg0[1] },
        },
      }
    },
    lualine_c = { {
      'filename',
      path = 1 -- relative path
    } },
    lualine_x = { large_file, treesitter_status, 'filetype' },
    lualine_y = { searchcount, 'progress' },
    lualine_z = { location_or_selected_lines }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'fugitive', 'quickfix' }
}


-- tabline
function Tabline()
  local line = ''
  local current_tabpage = a.nvim_get_current_tabpage()
  local tabs = a.nvim_list_tabpages()
  for tab_nb, tab_handle in ipairs(tabs) do
    -- tab info
    local highlight = tab_handle == current_tabpage and 'TabLineSel' or 'TabLine'
    local tabname_exists, tabname = pcall(a.nvim_tabpage_get_var, tab_handle, 'tabname')
    -- info about tab's current window
    local current_win = a.nvim_tabpage_get_win(tab_handle)
    local current_buf = a.nvim_win_get_buf(current_win)
    local current_name = a.nvim_buf_get_name(current_buf)
    -- info about all tab's windows
    local wins = {} -- get non floating/relative windows
    for _, window in ipairs(a.nvim_tabpage_list_wins(tab_handle)) do
      local config = a.nvim_win_get_config(window)
      if config.relative == "" then
        table.insert(wins, window)
      end
    end
    local wins_nb = #wins
    local modified = false
    for _, win_handle in ipairs(wins) do
      local buf = a.nvim_win_get_buf(win_handle)
      if a.nvim_get_option_value('modified', { buf = buf }) then
        modified = true
      end
    end
    -- format string
    line = line .. string.format("%%#%s#%%%dT %s%s%s ",
      highlight, tab_nb,
      tabname_exists and tabname or current_name:match("[^/]*$"),
      wins_nb ~= 1 and string.format(' (%d)', wins_nb) or '',
      modified and ' [+]' or ''
    )
  end
  line = line .. '%#TabLineFill#' .. '%T' -- end click region
  return line
end

vim.cmd([[set tabline=%!v:lua.Tabline()]])


-- winbar
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "oil" },
  callback = function()
    pcall(vim.api.nvim_set_option_value, "winbar",
      '%#Grey#' .. (require 'oil'.get_current_dir() or vim.fn.expand('%:b')),
      { scope = "local" })
  end
})
