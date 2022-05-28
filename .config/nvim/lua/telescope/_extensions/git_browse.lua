local git_browse = {}

local actions = require "telescope.actions"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"
local utils = require "telescope.utils"

local flatten = vim.tbl_flatten

local git_grep_cmd = { 'git', 'grep', '--line-number', '--column', '-I', '--ignore-case' }
local git_log_cmd = { "git", "log", "--pretty=oneline", "--abbrev-commit", "--", "." }

local escape_chars = function(string)
  return string.gsub(string, "[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$|%.]", {
    ["\\"] = "\\\\",
    ["-"] = "\\-",
    ["("] = "\\(",
    [")"] = "\\)",
    ["["] = "\\[",
    ["]"] = "\\]",
    ["{"] = "\\{",
    ["}"] = "\\}",
    ["?"] = "\\?",
    ["+"] = "\\+",
    ["*"] = "\\*",
    ["^"] = "\\^",
    ["$"] = "\\$",
    ["."] = "\\.",
  })
end

-- TODO: use fzf when available
local sorter_preserve_order = function(opts)
  opts = opts or {}
  local fzy = opts.fzy_mod or require "telescope.algos.fzy"

  return sorters.Sorter:new {
    scoring_function = function(_, prompt, line, _)
      if not fzy.has_match(prompt, line) then
        return -1
      end
      return 1
    end,

    highlighter = function(_, prompt, display)
      return fzy.positions(prompt, display)
    end,
  }
end

-- TODO: user commit previwer with this command
-- > git --no-pager show --no-color --pretty a55f44da1d72dff24741f643584f9078a77e50f2 | head

git_browse.live_grep = function(opts)
  if opts.is_bare then
    utils.notify("git_browse.live_grep", {
      msg = "This operation must be run in a work tree",
      level = "ERROR",
    })
    return
  end

  local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
  local git_command = utils.get_default(opts.git_command, git_grep_cmd)

  local live_grepper = finders.new_job(function(prompt)
    if not prompt or prompt == "" then
      return nil
    end
    return vim.tbl_flatten { git_command, recurse_submodules, "--", prompt }
  end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  pickers.new(opts, {
    prompt_title = "GitBrowse Live Grep",
    finder = live_grepper,
    previewer = conf.grep_previewer(opts),
    sorter = sorters.highlighter_only(opts),
  }):find()
end

git_browse.grep_string = function(opts)
  if opts.is_bare then
    utils.notify("git_browse.grep_string", {
      msg = "This operation must be run in a work tree",
      level = "ERROR",
    })
    return
  end

  local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
  local git_command = utils.get_default(opts.git_command, git_grep_cmd)

  local word = opts.search or vim.fn.expand "<cword>"
  local search = opts.use_regex and word or escape_chars(word)
  local word_match = opts.word_match
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == "function" then
    additional_args = opts.additional_args(opts)
  end

  local args = flatten {
    git_command,
    recurse_submodules,
    additional_args,
    word_match,
    "--",
    search,
  }

  pickers.new(opts, {
    prompt_title = "GitBrowse Find Word (" .. word .. ")",
    finder = finders.new_oneshot_job(args, opts),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

git_browse.commit_msgs = function(opts)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))
  local git_command = utils.get_default(opts.git_command, git_log_cmd)

  pickers.new(opts, {
    prompt_title = "Git Commits",
    finder = finders.new_oneshot_job(git_command, opts),
    previewer = previewers.git_commit_diff_to_parent.new(opts),
    sorter = sorter_preserve_order(opts),
    attach_mappings = function(_, map)
      actions.select_default:replace(actions.git_checkout)
      map("i", "<c-r>m", actions.git_reset_mixed)
      map("n", "<c-r>m", actions.git_reset_mixed)
      map("i", "<c-r>s", actions.git_reset_soft)
      map("n", "<c-r>s", actions.git_reset_soft)
      map("i", "<c-r>h", actions.git_reset_hard)
      map("n", "<c-r>h", actions.git_reset_hard)
      return true
    end,
  }):find()
end

local set_opts_cwd = function(opts)
  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  else
    opts.cwd = vim.loop.cwd()
  end

  -- Find root of git directory and remove trailing newline characters
  local git_root, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)
  local use_git_root = utils.get_default(opts.use_git_root, true)

  if ret ~= 0 then
    local in_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
    local in_bare = utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)

    if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
      error(opts.cwd .. " is not a git directory")
    elseif in_worktree[1] ~= "true" and in_bare[1] == "true" then
      opts.is_bare = true
    end
  else
    if use_git_root then
      opts.cwd = git_root[1]
    end
  end
end

local function apply_checks(mod)
  for k, v in pairs(mod) do
    mod[k] = function(opts)
      opts = vim.F.if_nil(opts, {})

      set_opts_cwd(opts)
      v(opts)
    end
  end

  return mod
end

local gb_with_checks = apply_checks(git_browse)

return require('telescope').register_extension({
  exports = {
    live_grep = gb_with_checks.live_grep,
    grep_string = gb_with_checks.grep_string,
    commit_msgs = gb_with_checks.commit_msgs,
  },
})
