require('neoclip').setup({
  keys = {
    telescope = {
      i = {
        select = '<cr>',
        paste = '<c-p>',
        paste_behind = '<c-s-p>',
        replay = '<c-q>',  -- replay a macro
        delete = '<c-d>',  -- delete an entry
        custom = {},
      },
      n = {
        select = '<cr>',
        paste = 'p',
        paste_behind = 'P',
        replay = 'q',
        delete = 'd',
        custom = {},
      },
    },
  },
})

require('telescope').setup{
  defaults = {
    dynamic_preview_title = true,
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
require('telescope').load_extension('git_browse')
require('telescope').load_extension('neoclip')
