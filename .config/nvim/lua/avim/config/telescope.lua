require('telescope').setup {
  defaults = {
    dynamic_preview_title = true,
    sorting_strategy = "ascending",
    prompt_prefix = " ",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    mappings = {
      i = {
        ["<C-k>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
      }
    }
  },
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('git_browse')
