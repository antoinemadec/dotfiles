-- appearance
if tonumber(os.getenv("TERM_COLORS")) >= 256 then
  vim.o.termguicolors = true
  vim.g.hg0 = 13
  vim.g.hg1 = 17
else
  vim.g.hg0 = 4
  vim.g.hg1 = 6
end
vim.g.gruvbox_material_background = 'soft'
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_palette = 'mix'
vim.cmd("colorscheme gruvbox-material")

-- other options
vim.opt.scrolloff      = 1                      -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff  = 5                      -- minimal number of screen columns to keep to the left/right of the cursor
vim.opt.cb             = 'unnamed,unnamedplus'  -- use * and + registers for yank
vim.opt.mouse          = 'a'                    -- allow to resize and copy/paste without selecting text outside of the window
vim.opt.backup         = false                  -- don't keep a backup file
vim.opt.textwidth      = 0                      -- don't wrap words by default
vim.opt.wildmode       = 'longest:full,full'    -- wildchar completion mode
vim.opt.hlsearch       = true                   -- highlight search
vim.opt.expandtab      = true                   -- tab expand to space
vim.opt.tabstop        = 2                      -- number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth     = 2                      -- number of spaces to use for each step of (auto)indent
vim.opt.isfname        = vim.opt.isfname - {',', '='} -- don't try to match certain characters in filename
vim.opt.number         = true
vim.opt.relativenumber = true                   -- show the line number relative to the line with the cursor
vim.opt.inccommand     = 'nosplit'
vim.opt.title          = true                   -- change terminal title
vim.opt.timeoutlen     = 500                    -- time in milliseconds to wait for a mapped sequence to complete
vim.opt.ttimeoutlen    = 50                     -- ms waited for a key code/sequence to complete. Allow faster insert to normal mode
vim.opt.complete       = '.,w,b,u'              -- specifies how keyword completion works when CTRL-P or CTRL-N are used
vim.opt.showcmd        = false                  -- don't show (partial) command in the last line of the screen
vim.opt.ignorecase     = true                   -- ignore case in pattern by default...
vim.opt.smartcase      = true                   -- .. except if it features at least one uppercase character
vim.opt.tags           = vim.opt.tags           + {'../tags;'}             -- get tags even if the current file is a symbolic/hard link
vim.opt.sessionoptions = vim.opt.sessionoptions + {'localoptions,globals'} -- all options and mappings
vim.opt.completeopt    = vim.opt.completeopt    + {'menuone,longest'}
vim.opt.foldmethod     = 'indent'
vim.opt.foldenable     = false
