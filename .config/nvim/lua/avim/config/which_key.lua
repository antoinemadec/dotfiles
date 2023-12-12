local function dir_split(cmd)
  vim.cmd(cmd .. ' ' .. vim.fn.GetCurrentBufferDir())
end

local function term_split(cmd)
  vim.cmd("cd " .. vim.fn.GetCurrentBufferDir())
  vim.cmd(cmd)
  vim.cmd([[
    cd -
    startinsert
    ]])
end

local wk = require("which-key")
wk.register(
  {
    -- top-level mappings
    ['/'] = {'<cmd>Telescope current_buffer_fuzzy_find<cr>', 'search in file'},
    [';'] = {'<cmd>Telescope commands<cr>',                  'commands'},
    ['y'] = {'<cmd>Telescope neoclip<cr>',                   'clipboard manager'},
    ['h'] = {'<cmd>Telescope help_tags<cr>',                 'vim help'},
    ['r'] = {'<cmd>Telescope resume<cr>',                    'resume Telescope'},
    -- find file
    ['f'] = {
      name = 'find_file',
      f    = {'<cmd>Telescope find_files follow=true<cr>',         'all files'},
      b    = {'<cmd>Telescope buffers<cr>',                        'buffers'},
      g    = {'<cmd>Telescope git_files show_untracked=false<cr>', 'git files'},
    },
    -- find word
    ['w'] = {
      name = 'find_word',
      w    = {'<cmd>Telescope live_grep<cr>',              'all words'},
      g    = {'<cmd>Telescope git_browse live_grep<cr>',   'git grep'},
      c    = {'<cmd>Telescope git_browse grep_string<cr>', 'current word git grep'},
    },
    -- split file
    ['s'] = {
      name = 'split_file',
      s = {'<C-w>s', 'horizontal'},
      v = {'<C-w>v', 'vertical'},
      t = {'<cmd>tab split<cr>', 'tab split'},
    },
    -- split dir
    ['d'] = {
      name = 'split_dir',
      w = {function() dir_split("e") end,    'current window'},
      s = {function() dir_split("sp") end,   'horizontal'},
      v = {function() dir_split("vsp") end,  'vertical'},
      t = {function() dir_split("tabe") end, 'tab split'},
    },
    -- cd in buffer's dir
    ['c'] = {
      name = 'cd_current',
      c = { '<cmd>cd `=GetCurrentBufferDir()`<cr>', 'global cd'},
      w = { '<cmd>lcd `=GetCurrentBufferDir()`<cr>', 'window cd'},
      t = { '<cmd>tcd `=GetCurrentBufferDir()`<cr>', 'tab cd'},
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
      s = {ToggleGstatus,                               'git status'},
      d = {'<cmd>Gdiffsplit<cr>',                       'git diff'},
      b = {'<cmd>Git blame<cr>',                        'git blame'},
      i = {'<cmd>Gitsigns preview_hunk<cr>',            'chunk info'},
      u = {'<cmd>Gitsigns reset_hunk<cr>',              'chunk undo'},
      c = {'<cmd>Telescope git_browse commit_msgs<cr>', 'git commits'},
    },
    -- lsp
    ['l'] = {
      name = 'lsp',
      d    = {'<cmd>Telescope diagnostics<cr>',                   'all diagnostics'},
      s    = {'<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'symbols'},
      t    = {'<cmd>Telescope git_browse live_tags<cr>',          'tags'},
      v    = {ToggleLspVirtualText,                               'toggle virtual text'},
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
