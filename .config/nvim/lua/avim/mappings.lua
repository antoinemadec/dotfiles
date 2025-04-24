-- functions
local t = _G.MUtils.t

local function map(mode, lhs, rhs, opts)
  -- silent by default
  opts = opts or {}
  opts.silent = opts.silent ~= false

  vim.keymap.set(mode, lhs, rhs, opts)
end

local function map_arrow_hjkl(mode, lhs, rhs, opt)
  local arrow_hjkl_table = {
    ['<Left>'] = 'h',
    ['<Down>'] = 'j',
    ['<Up>'] = 'k',
    ['<Right>'] = 'l',
    Left = 'h',
    Down = 'j',
    Up = 'k',
    Right = 'l'
  }
  -- arrow mapping
  map(mode, lhs, rhs, opt)
  -- hjkl mapping
  for arrow, hjkl in pairs(arrow_hjkl_table) do
    if string.find(lhs, arrow) then
      map(mode, string.gsub(lhs, arrow, hjkl), rhs, opt)
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

local function navigation_bar()
  if vim.bo.filetype == 'man' or vim.t.man_toc_win then
    require('window-movement').toggle_side_bar("toc_win", function() require 'man'.show_toc() end)
  elseif vim.bo.filetype == 'help' or vim.t.help_toc_win then
    require('window-movement').toggle_side_bar("toc_win", function() vim.cmd("normal gO") end)
  else
    require('avim.config.tagbar').toggle()
  end
end

local function next_sidebar_location(direction)
  if vim.t.toc_win then
    if direction == 1 then
      vim.cmd("lnext")
    else
      vim.cmd("lprev")
    end
  else
    vim.fn['tagbar#jumpToNearbyTag'](direction, "nearest", "s")
  end
end

local function toggle_diff()
  local current_win = vim.api.nvim_get_current_win()
  local command = vim.o.diff and "diffoff" or "diffthis"
  vim.cmd("windo " .. command)
  vim.api.nvim_set_current_win(current_win)
end

local function mapping_func_key_help()
  local opts = { title = "Function Keys", }
  local level = nil
  vim.notify([[
<F1>      Help            toggle
<F2>      Debugger
<F3>      Indent          toggle
<F4>      Tagbar          toggle
<F5>      Highlight_0     add
<F6>      Highlight_1     add
<F8>      Quickfix        toggle
<F9>      Spell           toggle
<F10>     Diff            toggle]], level, opts)
end

-- leader
vim.g.mapleader = t '<Space>'
vim.g.maplocalleader = ','

-- add multiple line movement to the jump list
map_arrow_hjkl('n', '<Down>', function() return smart_line_motion('j') end, { expr = true, noremap = true })
map_arrow_hjkl('n', '<Up>', function() return smart_line_motion('k') end, { expr = true, noremap = true })

-- terminal escape
map('t', '<Esc><Esc>', function() return smart_term_escape() end, { expr = true, noremap = true })

-- insert movement
map('i', '<C-h>', '<Left>')
map('i', '<C-j>', '<Down>', { remap = true })
map('i', '<C-k>', '<Up>', { remap = true })
map('i', '<C-l>', '<Right>')

for _, mode in pairs({ 'n', 'i', 't' }) do
  local esc_chars = (mode == 'i' or mode == 't') and '<C-\\><C-n>' or ''
  -- window movement
  map_arrow_hjkl(mode, '<A-Left>', esc_chars .. '<C-w>h')
  map_arrow_hjkl(mode, '<A-Down>', esc_chars .. '<C-w>j')
  map_arrow_hjkl(mode, '<A-Up>', esc_chars .. '<C-w>k')
  map_arrow_hjkl(mode, '<A-Right>', esc_chars .. '<C-w>l')
  map_arrow_hjkl(mode, '<A-S-Left>', function() require('window-movement').move_win_to_direction("left") end)
  map_arrow_hjkl(mode, '<A-S-Down>', function() require('window-movement').move_win_to_direction("down") end)
  map_arrow_hjkl(mode, '<A-S-Up>', function() require('window-movement').move_win_to_direction("up") end)
  map_arrow_hjkl(mode, '<A-S-Right>', function() require('window-movement').move_win_to_direction("right") end)
  map_arrow_hjkl(mode, '<A-q>', function() require('window-movement').quad_win_cycle() end)
  -- tab movement
  map_arrow_hjkl(mode, '<C-A-Left>', esc_chars .. 'gT')
  map_arrow_hjkl(mode, '<C-A-Right>', esc_chars .. 'gt')
  map_arrow_hjkl(mode, '<C-A-S-Left>', function() require('window-movement').move_win_to_tab("prev") end)
  map_arrow_hjkl(mode, '<C-A-S-Right>', function() require('window-movement').move_win_to_tab("next") end)
end
map('n', '<C-j>', '<C-e>')
map('n', '<C-k>', '<C-y>')

-- tab split
map('n', '<C-w><C-t>', ':tab split<cr>')
map('n', '<C-w>t', ':tab split<cr>')

-- function keys
map('n', '<F1>', mapping_func_key_help)
map('n', '<F2>', function() require("dapui").toggle() end)
map('n', '<F3>', ':ToggleIndent<cr>')
map('n', '<F4>', navigation_bar)
map('n', '<F5>', ':exe "HighlightGroupsAddWord " . hg0 . " 1"<cr>')
map('n', '\\<F5>', ':exe "HighlightGroupsClearGroup " . hg0 . " 1"<cr>')
map('n', '<F6>', ':exe "HighlightGroupsAddWord " . hg1 . " 1"<cr>')
map('n', '\\<F6>', ':exe "HighlightGroupsClearGroup " . hg1 . " 1"<cr>')
map('n', '<F8>', ':call asyncrun#quickfix_toggle(8)<cr>')
map('n', '<F9>', ':set spell!<cr>')
map('i', '<F9>', '<C-o> :set spell!<cr>')
map('n', '<F10>', toggle_diff)

-- git
map('n', ']g', ':silent Gitsigns next_hunk<CR>')
map('n', '[g', ':silent Gitsigns prev_hunk<CR>')
map('o', 'ig', ':<C-U>Gitsigns select_hunk<CR>')
map('x', 'ig', ':<C-U>Gitsigns select_hunk<CR>')

-- tags: select when multiple matches
map('n', '<C-LeftMouse>', 'g<C-]>')
map('n', '<C-]>', 'g<C-]>')
map('n', '<C-w>]', '<C-w>g<C-]>')
map('n', '<C-w><C-]>', '<C-w>g<C-]>')

-- quickfix location list
map('n', ']c', ':silent! cnext<cr>')
map('n', '[c', ':silent! cprev<cr>')
map('n', ']l', ':silent! lnext<cr>')
map('n', '[l', ':silent! lprev<cr>')
map('n', '[t', function() next_sidebar_location(-1) end)
map('n', ']t', function() next_sidebar_location(1) end)

-- misc
map('n', '\\r', ':RunCurrentBuffer<cr>')
map('n', '\\t', ':RunAndTimeCurrentBuffer<cr>')
map('v', '<LeftRelease>', '"*ygv') -- copy/paste with mouse select
map('x', 'ga', '<Plug>(EasyAlign)', { remap = true })
map('n', 'ga', '<Plug>(EasyAlign)', { remap = true })
map('x', 'gm', ':<C-U>lua _G.TUtils.indentation_to_bullets("\'<", "\'>")<CR>', { remap = true })
map('n', 'gm', ':<C-U>set opfunc=v:lua.TUtils.indentation_to_bullets_opfunc<CR>g@', { remap = true })
map('n', 'dO', ':1,$+1diffget<cr>:diffupdate<cr>')
map('n', 'dP', ':wincmd w<cr>:1,$+1diffget<cr>:wincmd w<cr>:diffupdate<cr>')
map('t', '\\cd', 'nvim_server_cmd "cd $PWD" -i<cr>')

-- LSP mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map('n', '\\d', vim.diagnostic.open_float)
map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
-- remap('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- return when buffer type is copilot-chat
    if vim.bo.filetype == 'copilot-chat' then
      return
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', require 'telescope.builtin'.lsp_definitions, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', 'gi', require 'telescope.builtin'.lsp_implementations, opts)
    -- map('n', '<C-s>', vim.lsp.buf.signature_help, opts)
    -- remap('n', '<space>D', vim.lsp.buf.type_definition, opts)
    map('n', '\\rn', vim.lsp.buf.rename, opts)
    map({ 'n', 'v' }, '\\ac', vim.lsp.buf.code_action, opts)
    map('n', 'gr', require 'telescope.builtin'.lsp_references, opts)
    map('n', '\\f', _G.LUtils.format, opts)
  end,
})

-- Duplicate selection and comment out the first instance.
function _G.duplicate_and_comment_lines()
  local start_line, end_line = vim.api.nvim_buf_get_mark(0, '[')[1], vim.api.nvim_buf_get_mark(0, ']')[1]
  -- NOTE: `nvim_buf_get_mark()` is 1-indexed, but `nvim_buf_get_lines()` is 0-indexed. Adjust accordingly.
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  -- Store cursor position because it might move when commenting out the lines.
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- Comment out the selection using the builtin gc operator.
  vim.cmd.normal({ 'gcc', range = { start_line, end_line } })
  -- Append a duplicate of the selected lines to the end of selection.
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, lines)
  -- Move cursor to the start of the duplicate lines.
  vim.api.nvim_win_set_cursor(0, { end_line + 1, cursor[2] })
end
vim.keymap.set({ 'n', 'x' }, 'yc', function()
  vim.opt.operatorfunc = 'v:lua.duplicate_and_comment_lines'
  return 'g@'
end, { expr = true, desc = 'Duplicate selection and comment out the first instance' })
vim.keymap.set('n', 'ycc', function()
  vim.opt.operatorfunc = 'v:lua.duplicate_and_comment_lines'
  return 'g@_'
end, { expr = true, desc = 'Duplicate [count] lines and comment out the first instance' })
