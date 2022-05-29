local M = {}

local sorters = require "telescope.sorters"

-- TODO: use fzf when available
M.preserve_order = function(opts)
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

return M
