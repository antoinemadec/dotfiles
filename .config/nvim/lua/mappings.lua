-- functions
local default_opts = {noremap=true, silent=true}

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function nvim_set_keymap_arrow_and_hjkl(mode, lhs, rhs, opt)
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

function _G.smart_term_escape()
  return vim.o.filetype == 'fzf' and t'<Esc>' or t'<C-\\>' .. t'<C-n>'
end


-- leader
vim.g.mapleader = t'<Space>'
vim.g.maplocalleader = ','

-- terminal escape
vim.api.nvim_set_keymap('t', '<Esc><Esc>', 'v:lua.smart_term_escape()', {expr = true, noremap = true})

-- insert movement
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>',  default_opts)
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>',  default_opts)
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>',    default_opts)
vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', default_opts)

for _,mode in pairs({'n', 'i', 't'}) do
  local esc_chars = (mode == 'i' or mode == 't') and '<C-\\><C-n>' or ''
  -- window movement
  nvim_set_keymap_arrow_and_hjkl(mode, '<A-Left>',      esc_chars .. '<C-w>h',                    default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<A-Down>',      esc_chars .. '<C-w>j',                    default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<A-Up>',        esc_chars .. '<C-w>k',                    default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<A-Right>',     esc_chars .. '<C-w>l',                    default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<A-S-Left>',    esc_chars .. '<C-w>H',                    default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<A-S-Down>',    esc_chars .. '<C-w>J',                    default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<A-S-Up>',      esc_chars .. '<C-w>K',                    default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<A-S-Right>',   esc_chars .. '<C-w>L',                    default_opts)
  -- tab movement
  nvim_set_keymap_arrow_and_hjkl(mode, '<C-A-Left>',    esc_chars .. 'gT',                        default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<C-A-Right>',   esc_chars .. 'gt',                        default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<C-A-S-Left>',  esc_chars .. ':call MoveToPrevTab()<CR>', default_opts)
  nvim_set_keymap_arrow_and_hjkl(mode, '<C-A-S-Right>', esc_chars .. ':call MoveToNextTab()<CR>', default_opts)
end

-- tab split
vim.api.nvim_set_keymap('n', '<C-w><C-t>', ':tab split<CR>', default_opts)
vim.api.nvim_set_keymap('n', '<C-w>t',     ':tab split<CR>', default_opts)

-- function keys
vim.api.nvim_set_keymap('n', '<F1>',   ':call MappingHelp()<CR>',                            default_opts)
vim.api.nvim_set_keymap('n', '<F2>',   ':call Debugger()<CR>',                               default_opts)
vim.api.nvim_set_keymap('n', '<F3>',   ':ToggleIndent<CR>',                                  default_opts)
vim.api.nvim_set_keymap('n', '<F4>',   ':TagbarToggle<CR>',                                  default_opts)
vim.api.nvim_set_keymap('n', '<F5>',   ':exe "HighlightGroupsAddWord " . hg0 . " 1"<CR>',    default_opts)
vim.api.nvim_set_keymap('n', '\\<F5>', ':exe "HighlightGroupsClearGroup " . hg0 . " 1"<CR>', default_opts)
vim.api.nvim_set_keymap('n', '<F6>',   ':exe "HighlightGroupsAddWord " . hg1 . " 1"<CR>',    default_opts)
vim.api.nvim_set_keymap('n', '\\<F6>', ':exe "HighlightGroupsClearGroup " . hg1 . " 1"<CR>', default_opts)
vim.api.nvim_set_keymap('n', '<F7>',   ':call ToggleTrailingSpace()<CR>',                    default_opts)
vim.api.nvim_set_keymap('n', '<F8>',   ':call asyncrun#quickfix_toggle(8)<CR>',              default_opts)
vim.api.nvim_set_keymap('n', '<F9>',   ':set spell!<CR>',                                    default_opts)
vim.api.nvim_set_keymap('i', '<F9>',   '<C-o> :set spell!<CR>',                              default_opts)
vim.api.nvim_set_keymap('n', '<F10>',  ':ToggleCompletion<CR>',                              default_opts)
vim.api.nvim_set_keymap('i', '<F10>',  '<C-o> :ToggleCompletion<CR>',                        default_opts)
