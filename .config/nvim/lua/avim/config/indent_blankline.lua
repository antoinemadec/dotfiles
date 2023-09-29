require("ibl").setup {
  indent = { char = "│" },
  exclude = {
    buftypes = {'help', 'terminal'},
    filetypes = {'startify', 'which_key', 'packer', 'mason'},
  },
}
