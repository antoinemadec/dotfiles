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
    ['/'] = {'<cmd>BLines<cr>', 'search in file'},
    [';'] = {'<cmd>Commands<cr>', 'commands'},
    -- find file
    ['f'] = {
      name = 'find_file',
      f    = {'<cmd>Files<cr>',    'all files'},
      b    = {'<cmd>Buffers<cr>',  'buffers'},
      g    = {'<cmd>GitFiles<cr>', 'git files'},
    },
    -- find word
    ['w'] = {
      name = 'find_word',
      w    = {'<cmd>Ag<cr>',    'all words'},
      g    = {'<cmd>GGrep<cr>', 'git grep'},
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
      s = {'<cmd>call ToggleGstatus()<cr>',           'git status'},
      d = {'<cmd>Gdiffsplit<cr>',               'git diff'},
      b = {'<cmd>Git blame<cr>',                'git blame'},
      i = {'<Plug>(coc-git-chunkinfo)', 'chunk info'},
      u = {'<cmd>CocCommand git.chunkUndo<cr>', 'chunk undo'},
      c = {'<cmd>Commits<cr>',                  'list git commits'},
    },
    -- lsp
    ['l'] = {
      name = 'lsp',
      a    = {'<cmd>CocFzfList actions<cr>',                   'actions'},
      b    = {'<cmd>CocFzfList diagnostics --current-buf<cr>', 'buffer diagnostics'},
      c    = {'<cmd>CocFzfList commands<cr>',                  'commands'},
      d    = {'<cmd>CocFzfList diagnostics<cr>',               'all diagnostics'},
      e    = {'<cmd>CocFzfList extensions<cr>',                'extensions'},
      l    = {'<cmd>CocFzfList<cr>',                           'lists'},
      o    = {'<cmd>CocFzfList outline<cr>',                   'outline'},
      p    = {'<cmd>CocFzfListResume<cr>',                     'previous list'},
      s    = {'<cmd>CocFzfList symbols<cr>',                   'symbols'},
      t    = {'<cmd>Tags<cr>',                                 'tags'},
      y    = {'<cmd>CocFzfList yank<cr>',                      'yank'},
    },
  }, { prefix = "<leader>" })
