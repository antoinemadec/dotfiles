local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local conf = require("telescope.config").values
local make_entry = require "telescope.make_entry"
local flatten = vim.tbl_flatten

local git_cmd = { 'git', 'grep', '--line-number', '--column'}

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

local git_live_grep = function(opts)
  opts = opts or {}

  local git_live_grepper = finders.new_job(function(prompt)
    if not prompt or prompt == "" then
      return nil
    end
    return flatten {git_cmd, '--', prompt}
  end, make_entry.gen_from_vimgrep())

  pickers.new(opts, {
    prompt_title = "Git Live Grep",
    finder = git_live_grepper,
    previewer = conf.grep_previewer(opts),
    sorter = sorters.highlighter_only(opts),
  }):find()
end

local git_grep_string = function(opts)
  local word = opts.search or vim.fn.expand "<cword>"
  local search = opts.use_regex and word or escape_chars(word)
  local word_match = opts.word_match
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == "function" then
    additional_args = opts.additional_args(opts)
  end

  local args = flatten {
    git_cmd,
    additional_args,
    word_match,
    "--",
    search,
  }

  pickers.new(opts, {
    prompt_title = "Git Find Word (" .. word .. ")",
    finder = finders.new_oneshot_job(args, opts),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

return require('telescope').register_extension({
  exports = {
    live_grep = git_live_grep,
    grep_string = git_grep_string,
  },
})
