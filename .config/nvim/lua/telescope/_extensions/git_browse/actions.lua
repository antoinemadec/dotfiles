  local M = {}
  local action_state = require "telescope.actions.state"

  -- TODO: open preview buffer
  M.do_stuff = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr) -- picker state
    put(current_picker.previewer)
  end

  return M
