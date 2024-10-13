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
  for _, win_handle in ipairs(require('window-movement').get_normal_windows()) do
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
    vim.notify("display trailing spaces", nil, { title = "UI" })
  else
    vim.notify("don't display trailing spaces", nil, { title = "UI" })
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
  preset = "modern",
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "", -- symbol prepended to a group
  },
})

local wrap = function(func, opts)
  local ok, msg = pcall(func, opts)
  if not ok then
    vim.notify(msg, vim.log.levels.WARN)
  end
end

wk.add({
  { "<leader>/",   "<cmd>Telescope current_buffer_fuzzy_find previewer=false<cr>",                            desc = "search in file" },
  { "<leader>;",   "<cmd>Telescope commands<cr>",                                                             desc = "commands" },

  { "<leader>b",   group = "debug" },
  { "<leader>bB",  '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>',        desc = "breakpoint condition" },
  { "<leader>bb",  '<cmd>lua require"dap".toggle_breakpoint()<cr>',                                           desc = "breakpoint" },
  { "<leader>be",  '<cmd>lua require"dapui".eval()<cr>',                                                      desc = "eval" },
  { "<leader>bl",  '<cmd>lua require"dap".run_last()<cr>',                                                    desc = "run last" },
  { "<leader>bp",  '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>', desc = "log point message" },
  { "<leader>br",  '<cmd>lua require"dap".continue()<cr>',                                                    desc = "run" },

  { "<leader>c",   group = "cd buffer dir" },
  { "<leader>cc",  function() cmd_on_buffer_dir('cd') end,                                                    desc = "global cd" },
  { "<leader>ct",  function() cmd_on_buffer_dir('tcd') end,                                                   desc = "tab cd" },
  { "<leader>cw",  function() cmd_on_buffer_dir('lcd') end,                                                   desc = "window cd" },

  { "<leader>d",   group = "split dir" },
  { "<leader>ds",  function() cmd_on_buffer_dir("sp") end,                                                    desc = "horizontal" },
  { "<leader>dt",  function() cmd_on_buffer_dir("tabe") end,                                                  desc = "tab split" },
  { "<leader>dv",  function() cmd_on_buffer_dir("vsp") end,                                                   desc = "vertical" },
  { "<leader>dw",  function() cmd_on_buffer_dir("e") end,                                                     desc = "current window" },

  { "<leader>f",   group = "find file" },
  { "<leader>fb",  "<cmd>Telescope buffers<cr>",                                                              desc = "buffers" },
  { "<leader>ff",  "<cmd>Telescope find_files follow=true<cr>",                                               desc = "all files" },
  { "<leader>fg",  function() wrap(require("telescope.builtin").git_files, { show_untracked = false }) end,   desc = "git files" },

  { "<leader>g",   group = "git" },
  { "<leader>gb",  "<cmd>Git blame<cr>",                                                                      desc = "git blame" },
  { "<leader>gc",  group = "commit" },
  { "<leader>gcb", function() wrap(require("telescope").extensions.git_browse.bcommit_msgs, {}) end,          desc = "git commits current buf only" },
  { "<leader>gcc", function() wrap(require("telescope").extensions.git_browse.commit_msgs, {}) end,           desc = "git commits" },
  { "<leader>gcd", function() wrap(require("telescope").extensions.git_browse.ccommit_msgs, {}) end,          desc = "git commits current dir only" },
  { "<leader>gd",  "<cmd>Gdiffsplit<cr>",                                                                     desc = "git diff" },
  { "<leader>gi",  "<cmd>Gitsigns preview_hunk<cr>",                                                          desc = "chunk info" },
  { "<leader>gs",  function() ToggleGstatus() end,                                                            desc = "git status" },
  { "<leader>gu",  "<cmd>Gitsigns reset_hunk<cr>",                                                            desc = "chunk undo" },
  { "<leader>h",   "<cmd>Telescope help_tags<cr>",                                                            desc = "vim help" },

  { "<leader>l",   group = "lsp" },
  { "<leader>ld",  "<cmd>Telescope diagnostics<cr>",                                                          desc = "all diagnostics" },
  { "<leader>ls",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                                        desc = "symbols" },
  { "<leader>lt",  "<cmd>Telescope git_browse live_tags<cr>",                                                 desc = "tags" },
  { "<leader>lv",  function() ToggleLspVirtualText() end,                                                     desc = "toggle virtual text" },
  { "<leader>lwa", vim.lsp.buf.add_workspace_folder,                                                          desc = "add workspace folder" },
  { "<leader>lwl", function() put(vim.lsp.buf.list_workspace_folders()) end,                                  desc = "list workspace folders" },
  { "<leader>lwr", vim.lsp.buf.remove_workspace_folder,                                                       desc = "remove workspace folder" },
  { "<leader>m",   "<cmd>MarkdownPreviewToggle<cr>",                                                          desc = "markdown preview" },

  { "<leader>s",   group = "split file" },
  { "<leader>ss",  "<C-w>s",                                                                                  desc = "horizontal" },
  { "<leader>st",  "<cmd>tab split<cr>",                                                                      desc = "tab split" },
  { "<leader>sv",  "<C-w>v",                                                                                  desc = "vertical" },

  { "<leader>t",   group = "terminal" },
  { "<leader>ts",  function() term_split("TS") end,                                                           desc = "horizontal" },
  { "<leader>tt",  function() term_split("TT") end,                                                           desc = "tab split" },
  { "<leader>tv",  function() term_split("TV") end,                                                           desc = "vertical" },
  { "<leader>tw",  function() term_split("T") end,                                                            desc = "current window" },

  { "<leader>u",   group = "change UI" },
  { "<leader>uc",  ui_toggle_cmdheight,                                                                       desc = "toggle cmdline height" },
  { "<leader>ul",  ui_toggle_large_file_cutoff,                                                               desc = "toggle large file cutoff" },
  { "<leader>un",  ui_cycle_number,                                                                           desc = "cycle trough relative, norelative, nonumber" },
  { "<leader>ut",  ui_toggle_trailing_space,                                                                  desc = "toggle trailing space display" },

  { "<leader>w",   group = "find word" },
  { "<leader>wc",  function() wrap(require("telescope").extensions.git_browse.grep_string, {}) end,           desc = "current word git grep" },
  { "<leader>wg",  function() wrap(require("telescope").extensions.git_browse.live_grep, {}) end,             desc = "git grep" },
  { "<leader>ww",  "<cmd>Telescope live_grep<cr>",                                                            desc = "all words" },
})
