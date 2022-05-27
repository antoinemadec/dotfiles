local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local conf = require("telescope.config").values
local make_entry = require "telescope.make_entry"

local git_grepper = finders.new_job(function(prompt)
  if not prompt or prompt == "" then
    return nil
  end

  return { 'git', 'grep', '--line-number', '--column', '--', prompt }
end, make_entry.gen_from_vimgrep())

local git_grep = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Live Git Grep",
    finder = git_grepper,
    previewer = conf.grep_previewer(opts),
    sorter = sorters.highlighter_only(opts),
  }):find()
end

return require('telescope').register_extension({
  exports = {
    git_grep = git_grep,
  },
})
