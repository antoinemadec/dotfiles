require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
      }
    }
  },
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('coc')
vim.cmd([[
let g:coc_enable_locationlist = 0
autocmd User CocLocationsChange Telescope coc locations
]])
require('telescope').load_extension('notify')
require('telescope').load_extension('git_grep')
