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

vim.g.coc_enable_locationlist = 0
vim.api.nvim_create_autocmd("User", {
  pattern = "CocLocationsChange",
  command = "Telescope coc locations"
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
