-- functions
local default_opts = { noremap = true, silent = true }
local map_opts = { noremap = false, silent = true }
local plug_opts = { noremap = false, silent = true }
local remap = vim.keymap.set
local t = _G.MUtils.t

local function remap_arrow_hjkl(mode, lhs, rhs, opt)
  local arrow_hjkl_table = {
    ['<Left>'] = 'h', ['<Down>'] = 'j', ['<Up>'] = 'k', ['<Right>'] = 'l',
    Left = 'h', Down = 'j', Up = 'k', Right = 'l'
  }
  -- arrow mapping
  remap(mode, lhs, rhs, opt)
  -- hjkl mapping
  for arrow, hjkl in pairs(arrow_hjkl_table) do
    if string.find(lhs, arrow) then
      remap(mode, string.gsub(lhs, arrow, hjkl), rhs, opt)
      return
    end
  end
end

local function smart_term_escape()
  return vim.o.filetype == 'fzf' and '<Esc>' or '<C-\\>' .. '<C-n>'
end

local function smart_line_motion(key)
  return vim.v.count > 1 and "m'" .. vim.v.count .. key or key
end

function _G.MUtils.mapping_func_key_help()
  if vim.b.help_scratch_open then
    vim.cmd('q')
  else
    local help_array = string.split([[
HELP FUNCTION KEYS
<F1>      *Help*            toggle
<F2>      *Debugger*
<F3>      *Indent*          toggle
<F4>      *Tagbar*          toggle
<F5>      *Highlight_0*     add
\<F5>     *Highlight_0*     remove
<F6>      *Highlight_1*     add
\<F6>     *Highlight_1*     remove
<F7>      *TrailingSpace*   toggle
<F8>      *Quickfix*        toggle
<F9>      *Spell*           toggle
<F10>     *Completion*      toggle]], "\n")
    vim.cmd('Scratch' .. #help_array)
    vim.api.nvim_put(help_array, '', false, false)
    vim.bo.filetype = 'help'
    vim.b.help_scratch_open = true
  end
end

-- leader
vim.g.mapleader = t '<Space>'
vim.g.maplocalleader = ','

-- add multiple line movement to the jump list
remap_arrow_hjkl('n', '<Down>', function() return smart_line_motion('j') end, { expr = true, noremap = true })
remap_arrow_hjkl('n', '<Up>', function() return smart_line_motion('k') end, { expr = true, noremap = true })

-- terminal escape
remap('t', '<Esc><Esc>', function() return smart_term_escape() end, { expr = true, noremap = true })

-- insert movement
remap('i', '<C-h>', '<Left>', default_opts)
remap('i', '<C-j>', '<Down>', map_opts)
remap('i', '<C-k>', '<Up>', map_opts)
remap('i', '<C-l>', '<Right>', default_opts)

for _, mode in pairs({ 'n', 'i', 't' }) do
  local esc_chars = (mode == 'i' or mode == 't') and '<C-\\><C-n>' or ''
  -- window movement
  remap_arrow_hjkl(mode, '<A-Left>', esc_chars .. '<C-w>h', default_opts)
  remap_arrow_hjkl(mode, '<A-Down>', esc_chars .. '<C-w>j', default_opts)
  remap_arrow_hjkl(mode, '<A-Up>', esc_chars .. '<C-w>k', default_opts)
  remap_arrow_hjkl(mode, '<A-Right>', esc_chars .. '<C-w>l', default_opts)
  remap_arrow_hjkl(mode, '<A-S-Left>', esc_chars .. '<C-w>H', default_opts)
  remap_arrow_hjkl(mode, '<A-S-Down>', esc_chars .. '<C-w>J', default_opts)
  remap_arrow_hjkl(mode, '<A-S-Up>', esc_chars .. '<C-w>K', default_opts)
  remap_arrow_hjkl(mode, '<A-S-Right>', esc_chars .. '<C-w>L', default_opts)
  remap_arrow_hjkl(mode, '<A-q>', function () _G.WUtils.quad_win_cycle() end, default_opts)
  -- tab movement
  remap_arrow_hjkl(mode, '<C-A-Left>', esc_chars .. 'gT', default_opts)
  remap_arrow_hjkl(mode, '<C-A-Right>', esc_chars .. 'gt', default_opts)
  remap_arrow_hjkl(mode, '<C-A-S-Left>', function() _G.WUtils.move_win_to_tab("prev") end, default_opts)
  remap_arrow_hjkl(mode, '<C-A-S-Right>', function() _G.WUtils.move_win_to_tab("next") end, default_opts)
end
remap_arrow_hjkl('n', '<C-Down>', '<C-e>', default_opts)
remap_arrow_hjkl('n', '<C-Up>', '<C-y>', default_opts)

-- tab split
remap('n', '<C-w><C-t>', ':tab split<cr>', default_opts)
remap('n', '<C-w>t', ':tab split<cr>', default_opts)

-- function keys
remap('n', '<F1>', ':call v:lua.MUtils.mapping_func_key_help()<cr>', default_opts)
remap('n', '<F2>', ':call Debugger()<cr>', default_opts)
remap('n', '<F3>', ':ToggleIndent<cr>', default_opts)
remap('n', '<F4>', ':TagbarToggle<cr>', default_opts)
remap('n', '<F5>', ':exe "HighlightGroupsAddWord " . hg0 . " 1"<cr>', default_opts)
remap('n', '\\<F5>', ':exe "HighlightGroupsClearGroup " . hg0 . " 1"<cr>', default_opts)
remap('n', '<F6>', ':exe "HighlightGroupsAddWord " . hg1 . " 1"<cr>', default_opts)
remap('n', '\\<F6>', ':exe "HighlightGroupsClearGroup " . hg1 . " 1"<cr>', default_opts)
remap('n', '<F7>', ':call ToggleTrailingSpace()<cr>', default_opts)
remap('n', '<F8>', ':call asyncrun#quickfix_toggle(8)<cr>', default_opts)
remap('n', '<F9>', ':set spell!<cr>', default_opts)
remap('i', '<F9>', '<C-o> :set spell!<cr>', default_opts)
remap('n', '<F10>', ':ToggleCompletion<cr>', default_opts)
remap('i', '<F10>', '<C-o> :ToggleCompletion<cr>', default_opts)

-- git
remap('n', ']g', ':Gitsigns next_hunk<CR>', default_opts)
remap('n', '[g', ':Gitsigns prev_hunk<CR>', default_opts)
remap('o', 'ig', ':<C-U>Gitsigns select_hunk<CR>', default_opts)
remap('x', 'ig', ':<C-U>Gitsigns select_hunk<CR>', default_opts)

-- misc
---- copy/paste with mouse select
remap('v', '<LeftRelease>', '"*ygv', default_opts)
---- TODO: search for visually selected text
remap('x', 'ga', '<Plug>(EasyAlign)', plug_opts)
remap('n', 'ga', '<Plug>(EasyAlign)', plug_opts)
remap('n', 'dO', ':1,$+1diffget<cr>:diffupdate<cr>', default_opts)
remap('n', 'dP', ':wincmd w<cr>:1,$+1diffget<cr>:wincmd w<cr>:diffupdate<cr>', default_opts)
remap('t', '\\cd', 'vim_server_cmd "cd $PWD" -i<cr>', default_opts)
