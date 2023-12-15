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

local function navigation_bar()
  if vim.bo.filetype == 'man' or vim.t.man_toc_win then
    if vim.t.man_toc_win then
      vim.api.nvim_win_close(vim.t.man_toc_win, true)
      vim.t.man_toc_win = nil
    else
      require'man'.show_toc()
      vim.cmd("wincmd L")
      vim.cmd("vertical resize 40")
      vim.wo.winfixwidth = true
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.t.man_toc_win = vim.api.nvim_get_current_win()
      vim.cmd("wincmd p")
    end
  else
    vim.cmd("TagbarToggle")
  end
end

local function toggle_diff()
  local current_win = vim.api.nvim_get_current_win()
  local command = vim.o.diff and "diffoff" or "diffthis"
  vim.cmd("windo " .. command)
  vim.api.nvim_set_current_win(current_win)
end

local function mapping_func_key_help()
  local notify = require('notify')
  local opts = { title = "Function Keys", timeout = false, }
  local level = nil
  if vim.g.mapping_func_key_help then
    vim.g.mapping_func_key_help = false
    notify.dismiss()
  else
    vim.g.mapping_func_key_help = true
    notify.notify([[
<F1>      Help            toggle
<F2>      Debugger
<F3>      Indent          toggle
<F4>      Tagbar          toggle
<F5>      Highlight_0     add
<F6>      Highlight_1     add
<F7>      TrailingSpace   toggle
<F8>      Quickfix        toggle
<F9>      Spell           toggle
<F10>     Diff            toggle]],level, opts)
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
remap('n', '<F1>', mapping_func_key_help, default_opts)
remap('n', '<F2>', function() require("dapui").toggle() end, default_opts)
remap('n', '<F3>', ':ToggleIndent<cr>', default_opts)
remap('n', '<F4>', navigation_bar, default_opts)
remap('n', '<F5>', ':exe "HighlightGroupsAddWord " . hg0 . " 1"<cr>', default_opts)
remap('n', '\\<F5>', ':exe "HighlightGroupsClearGroup " . hg0 . " 1"<cr>', default_opts)
remap('n', '<F6>', ':exe "HighlightGroupsAddWord " . hg1 . " 1"<cr>', default_opts)
remap('n', '\\<F6>', ':exe "HighlightGroupsClearGroup " . hg1 . " 1"<cr>', default_opts)
remap('n', '<F7>', ':call ToggleTrailingSpace()<cr>', default_opts)
remap('n', '<F8>', ':call asyncrun#quickfix_toggle(8)<cr>', default_opts)
remap('n', '<F9>', ':set spell!<cr>', default_opts)
remap('i', '<F9>', '<C-o> :set spell!<cr>', default_opts)
remap('n', '<F10>', toggle_diff, default_opts)

-- git
remap('n', ']g', ':Gitsigns next_hunk<CR>', default_opts)
remap('n', '[g', ':Gitsigns prev_hunk<CR>', default_opts)
remap('o', 'ig', ':<C-U>Gitsigns select_hunk<CR>', default_opts)
remap('x', 'ig', ':<C-U>Gitsigns select_hunk<CR>', default_opts)

-- tags: select when multiple matches
remap('n', '<C-LeftMouse>', 'g<C-]>', default_opts)
remap('n', '<C-]>', 'g<C-]>', default_opts)
remap('n', '<C-w>]', '<C-w>g<C-]>', default_opts)
remap('n', '<C-w><C-]>', '<C-w>g<C-]>', default_opts)

-- misc
remap('v', '<LeftRelease>', '"*ygv', default_opts) -- copy/paste with mouse select
remap('x', 'ga', '<Plug>(EasyAlign)', plug_opts)
remap('n', 'ga', '<Plug>(EasyAlign)', plug_opts)
remap('n', '<C-S-Up>', '<Plug>(VM-Add-Cursor-Up)', plug_opts)
remap('n', '<C-S-Down>', '<Plug>(VM-Add-Cursor-Down)', plug_opts)
remap('n', 'dO', ':1,$+1diffget<cr>:diffupdate<cr>', default_opts)
remap('n', 'dP', ':wincmd w<cr>:1,$+1diffget<cr>:wincmd w<cr>:diffupdate<cr>', default_opts)
remap('t', '\\cd', 'nvim_server_cmd "cd $PWD" -i<cr>', default_opts)

-- LSP mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '\\d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', require'telescope.builtin'.lsp_definitions, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi',  require'telescope.builtin'.lsp_implementations, opts)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '\\rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '\\ac', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', require'telescope.builtin'.lsp_references, opts)
    vim.keymap.set('n', '\\f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
