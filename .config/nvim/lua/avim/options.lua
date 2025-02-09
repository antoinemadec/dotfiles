-- appearance
vim.g.hg0              = 13
vim.g.hg1              = 17
vim.opt.termguicolors  = true

vim.opt.expandtab      = true  -- tab expand to space
vim.opt.tabstop        = 2     -- number of spaces that a <Tab> in the file counts for
vim.opt.number         = true
vim.opt.relativenumber = true  -- show the line number relative to the line with the cursor
vim.opt.scrolloff      = 1     -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff  = 5     -- minimal number of screen columns to keep to the left/right of the cursor
vim.opt.shiftwidth     = 2     -- number of spaces to use for each step of (auto)indent
vim.opt.showcmd        = false -- don't show (partial) command in the last line of the screen
vim.opt.title          = true  -- change terminal title
vim.opt.wrap           = false -- when on, lines longer than the width of the window will wrap

-- other options
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.updatetime     = 100                   -- delay for CursorHold
vim.opt.cb             = 'unnamed,unnamedplus' -- use * and + registers for yank
vim.opt.complete       =
'.,w,b,u'                                      -- specifies how keyword completion works when CTRL-P or CTRL-N are used
vim.opt.completeopt    = vim.opt.completeopt + { 'menuone,longest' }
vim.opt.foldenable     = false
vim.opt.foldmethod     = 'indent'
vim.opt.ignorecase     = true                                                -- ignore case in pattern by default...
vim.opt.smartcase      = true                                                -- ... except if it features at least one uppercase character
vim.opt.isfname        = vim.opt.isfname -
    { ',', '=' }                                                             -- don't try to match certain characters in filename
vim.opt.mouse          =
'a'                                                                          -- allow to resize and copy/paste without selecting text outside of the window
vim.opt.sessionoptions = vim.opt.sessionoptions + { 'localoptions,globals' } -- all options and mappings
vim.opt.tags           = vim.opt.tags +
    { '../tags;' }                                                           -- get tags even if the current file is a symbolic/hard link
vim.opt.timeoutlen     = 500                                                 -- time in milliseconds to wait for a mapped sequence to complete
vim.opt.ttimeoutlen    = 50                                                  -- ms waited for a key code/sequence to complete. Allow faster insert to normal mode
vim.opt.undofile       = true                                                -- when on, vim automatically saves undo history to an undo file
vim.opt.wildmode       = 'longest:full,full'                                 -- wildchar completion mode
vim.opt.cmdheight      = 0                                                   -- height of the command bar

-- man_mode: no status line
if vim.g.man_mode then
  vim.opt.laststatus = 0
end

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- downgrade options when file is too big
--- Set window-local options.
---@param win number
---@param bo vim.bo
local function change_window_options(win, bo)
  for k, v in pairs(bo or {}) do
    vim.api.nvim_set_option_value(k, v, { win = win })
  end
end

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = { "*" },
  callback = function(_)
    if _G.is_large_file() then
      change_window_options(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
    end
  end
})
