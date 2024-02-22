local function get_buffer_dir()
  if vim.b.oil_ready then
    return require("oil").get_current_dir()
  elseif vim.fn.expand('%') == "" or vim.bo.buftype == 'terminal' then
    return "."
  else
    return vim.fn.expand('%:h')
  end
end

local function cmd_on_buffer_dir(cmd)
  vim.cmd(cmd .. ' ' .. get_buffer_dir())
end

local function term_split(cmd)
  vim.cmd("cd " .. get_buffer_dir())
  vim.cmd(cmd)
  vim.cmd([[
    cd -
    startinsert
    ]])
end

local function ui_cycle_number()
  for _, win_handle in ipairs(_G.WUtils.get_normal_windows()) do
    local win_opt = vim.wo[win_handle]
    if win_opt.relativenumber then
      win_opt.number = true
      win_opt.relativenumber = false
    elseif win_opt.number then
      win_opt.number = false
      win_opt.relativenumber = false
    else
      win_opt.number = true
      win_opt.relativenumber = true
    end
  end
end

local function ui_toggle_large_file_cutoff()
  if vim.g.large_file_cutoff ~= 0 then
    vim.g.large_file_cutoff_bak = vim.g.large_file_cutoff
    vim.g.large_file_cutoff = 0
  else
    vim.g.large_file_cutoff = vim.g.large_file_cutoff_bak
  end
end

local function ui_toggle_trailing_space()
  vim.api.nvim_call_function('ToggleTrailingSpace', {})
  if vim.o.list then
    vim.notify("display trailing spaces", nil, {title = "UI"})
  else
    vim.notify("don't display trailing spaces", nil, {title = "UI"})
  end
end

local function ui_toggle_cmdheight()
  if vim.o.cmdheight == 0 then
    vim.o.cmdheight = 1
  else
    vim.o.cmdheight = 0
  end
end

local wk = require("which-key")

wk.setup({
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "", -- symbol prepended to a group
  },
})

wk.register(
  {
    -- top-level mappings
    ['/'] = {'<cmd>Telescope current_buffer_fuzzy_find<cr>', 'search in file'},
    [';'] = {'<cmd>Telescope commands<cr>',                  'commands'},
    ['y'] = {'<cmd>Telescope neoclip<cr>',                   'clipboard manager'},
    ['h'] = {'<cmd>Telescope help_tags<cr>',                 'vim help'},
    -- nvim UI
    ['u'] = {
      name = 'change UI',
      c    = {ui_toggle_cmdheight,         'toggle cmdline height'},
      n    = {ui_cycle_number,             'cycle trough relative, norelative, nonumber'},
      l    = {ui_toggle_large_file_cutoff, 'toggle large file cutoff'},
      t    = {ui_toggle_trailing_space,    'toggle trailing space display'},
    },
    -- find file
    ['f'] = {
      name = 'find file',
      f    = {'<cmd>Telescope find_files follow=true<cr>',         'all files'},
      b    = {'<cmd>Telescope buffers<cr>',                        'buffers'},
      g    = {'<cmd>Telescope git_files show_untracked=false<cr>', 'git files'},
    },
    -- find word
    ['w'] = {
      name = 'find word',
      w    = {'<cmd>Telescope live_grep<cr>',              'all words'},
      g    = {'<cmd>Telescope git_browse live_grep<cr>',   'git grep'},
      c    = {'<cmd>Telescope git_browse grep_string<cr>', 'current word git grep'},
    },
    -- split file
    ['s'] = {
      name = 'split file',
      s = {'<C-w>s', 'horizontal'},
      v = {'<C-w>v', 'vertical'},
      t = {'<cmd>tab split<cr>', 'tab split'},
    },
    -- split dir
    ['d'] = {
      name = 'split dir',
      w = {function() cmd_on_buffer_dir("e") end,    'current window'},
      s = {function() cmd_on_buffer_dir("sp") end,   'horizontal'},
      v = {function() cmd_on_buffer_dir("vsp") end,  'vertical'},
      t = {function() cmd_on_buffer_dir("tabe") end, 'tab split'},
    },
    -- cd in buffer's dir
    ['c'] = {
      name = 'cd buffer dir',
      c = { function() cmd_on_buffer_dir('cd') end,  'global cd'},
      w = { function() cmd_on_buffer_dir('lcd') end, 'window cd'},
      t = { function() cmd_on_buffer_dir('tcd') end, 'tab cd'},
    },
    -- terminal
    ['t'] = {
      name = 'terminal',
      w = {function() term_split("T") end,  'current window'},
      s = {function() term_split("TS") end, 'horizontal'},
      v = {function() term_split("TV") end, 'vertical'},
      t = {function() term_split("TT") end, 'tab split'},
    },
    -- git
    ['g'] = {
      name = 'git',
      s = {ToggleGstatus,                                 'git status'},
      d = {'<cmd>Gdiffsplit<cr>',                         'git diff'},
      b = {'<cmd>Git blame<cr>',                          'git blame'},
      i = {'<cmd>Gitsigns preview_hunk<cr>',              'chunk info'},
      u = {'<cmd>Gitsigns reset_hunk<cr>',                'chunk undo'},
      cc = {'<cmd>Telescope git_browse commit_msgs<cr>',  'git commits'},
      cb = {'<cmd>Telescope git_browse bcommit_msgs<cr>', 'git commits current buf only'},
      cd = {'<cmd>Telescope git_browse ccommit_msgs<cr>', 'git commits current dir only'},
    },
    -- lsp
    ['l'] = {
      name = 'lsp',
      d    = {'<cmd>Telescope diagnostics<cr>',                         'all diagnostics'},
      s    = {'<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',       'symbols'},
      t    = {'<cmd>Telescope git_browse live_tags<cr>',                'tags'},
      v    = {ToggleLspVirtualText,                                     'toggle virtual text'},
      wa   = {vim.lsp.buf.add_workspace_folder,                         'add workspace folder'},
      wr   = {vim.lsp.buf.remove_workspace_folder,                      'remove workspace folder'},
      wl   = {function() put(vim.lsp.buf.list_workspace_folders()) end, 'list workspace folders'},
    },
    -- DAP
    ['b'] = {
      name = 'debug',
      B = {'<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>',        'breakpoint condition'},
      b = {'<cmd>lua require"dap".toggle_breakpoint()<cr>',                                           'breakpoint'},
      e = {'<cmd>lua require"dapui".eval()<cr>',                                                      'eval'},
      l = {'<cmd>lua require"dap".run_last()<cr>',                                                    'run last'},
      p = {'<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>', 'log point message'},
      r = {'<cmd>lua require"dap".continue()<cr>',                                                    'run'},
    },
  }, { prefix = "<leader>" })
