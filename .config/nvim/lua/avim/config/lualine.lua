local gb_cfg = vim.fn['gruvbox_material#get_configuration']()
local palette = vim.fn['gruvbox_material#get_palette'](gb_cfg.background, gb_cfg.foreground, { dummy = 0 })
local ts_parsers = require "nvim-treesitter.parsers"
local a = vim.api


-- statusline
vim.cmd([[
autocmd CursorHold,CursorHoldI * call UpdateCurrentTag()

function UpdateCurrentTag()
  if !exists('g:tagbar_stl_' . &ft)
    return
  endif
  if exists('g:tagbar_stl_disable') && g:tagbar_stl_disable
    let b:stl_current_tag = '[off]'
    return
  endif
  let b:stl_current_tag =  tagbar#currenttagtype('[%s]', '') . tagbar#currenttag(' %s', '')
endfunction

command! ToggleTagbarStl call ToggleTagbarStl()
function ToggleTagbarStl()
  let g:tagbar_stl_disable = exists('g:tagbar_stl_disable') ? !g:tagbar_stl_disable : 1
  if g:tagbar_stl_disable
    call tagbar#StopAutoUpdate()
  endif
endfunction
]])

local function get_function_name()
  local info
  if vim.b.coc_current_function and vim.b.coc_current_function ~= "" then
    info = vim.b.coc_current_function
  else
    info = vim.b.stl_current_tag
  end
  return info or ''
end

local function location_or_selected_lines()
  local pos_l = vim.fn.getpos('.')
  local pos_v = vim.fn.getpos('v')
  local d_line = math.abs(pos_l[2] - pos_v[2]) + 1
  local d_col = math.abs(pos_l[3] - pos_v[3]) + 1
  local s = string.format("<%0d,%0d>", d_line, d_col)
  return (d_line ~= 1 or d_col ~= 1) and s or '%3l:%-2v'
end

local function treesitter_status()
  return ts_parsers.has_parser() and "🌳" or ""
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
        'g:coc_status',
        color = { bg = palette.bg_visual_blue[1] }
      },
      {
        get_function_name,
        color = { bg = palette.bg_visual_blue[1] }
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'coc' },
        diagnostics_color = {
          error = { bg = palette.red[1], fg = palette.bg0[1] },
          warn  = { bg = palette.yellow[1], fg = palette.bg0[1] },
          info  = { bg = palette.blue[1], fg = palette.bg0[1] },
          hint  = { bg = palette.aqua[1], fg = palette.bg0[1] },
        },
      }
    },
    lualine_c = { {
      'filename',
      path = 1 -- relative path
    } },
    lualine_x = { treesitter_status, 'filetype' },
    lualine_y = { 'progress' },
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
    local wins = a.nvim_tabpage_list_wins(tab_handle)
    local wins_nb = #wins
    local modified = false
    for _, win_handle in ipairs(wins) do
      local buf = a.nvim_win_get_buf(win_handle)
      if a.nvim_buf_get_option(buf, 'modified') then
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
