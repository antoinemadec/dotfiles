local M = {}
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"
local utils = require "telescope.utils"

local gb_actions = require('telescope._extensions.git_browse.actions')
local gb_previewers = require('telescope._extensions.git_browse.previewers')
local gb_sorters = require('telescope._extensions.git_browse.sorters')
local gb_utils = require('telescope._extensions.git_browse.utils')

local git_grep_command = { 'git', 'grep', '--line-number', '--column', '-I', '--ignore-case' }
local git_log_command = { "git", "log", "--pretty=oneline", "--abbrev-commit", "--", "." }

M.live_grep = function(opts)
  if opts.is_bare then
    utils.notify("git_browse.live_grep", {
      msg = "This operation must be run in a work tree",
      level = "ERROR",
    })
    return
  end

  local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
  local git_command = utils.get_default(opts.git_command, git_grep_command)

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

M.grep_string = function(opts)
  if opts.is_bare then
    utils.notify("git_browse.grep_string", {
      msg = "This operation must be run in a work tree",
      level = "ERROR",
    })
    return
  end

  local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
  local git_command = utils.get_default(opts.git_command, git_grep_command)

  local word = opts.search or vim.fn.expand "<cword>"
  local search = opts.use_regex and word or gb_utils.escape_chars(word)
  local word_match = opts.word_match
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == "function" then
    additional_args = opts.additional_args(opts)
  end

  local args = vim.tbl_flatten {
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

M.commit_msgs = function(opts)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))
  local git_command = utils.get_default(opts.git_command, git_log_command)

  pickers.new(opts, {
    prompt_title = "Git Commits",
    finder = finders.new_oneshot_job(git_command, opts),
    previewer = gb_previewers.git_commit_diff_to_parent.new(opts),
    sorter = gb_sorters.preserve_order(opts),
    attach_mappings = function(_, map)
      actions.select_default:replace(gb_actions.do_stuff)
      return true
    end,
  }):find()
end

local gb_with_checks = gb_utils.apply_checks(M)

return require('telescope').register_extension({
  exports = {
    live_grep = gb_with_checks.live_grep,
    grep_string = gb_with_checks.grep_string,
    commit_msgs = gb_with_checks.commit_msgs,
  },
})
