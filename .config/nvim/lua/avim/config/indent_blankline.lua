require("ibl").setup {
  indent = { char = "│" },
  exclude = {
    buftypes = {'help', 'terminal'},
    filetypes = {'startify', 'which_key', 'packer', 'mason'},
  },
  scope = {
    show_start = false,
    show_end = false,
  }
}

local hooks = require "ibl.hooks"
hooks.register(
hooks.type.ACTIVE,
function(bufnr)
  return vim.api.nvim_buf_line_count(bufnr) < vim.g.large_file_cutoff
end
)
