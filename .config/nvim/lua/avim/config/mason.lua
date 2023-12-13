require("mason").setup({
  PATH = "skip", -- taken care of in lsp.lua
})
require("mason-lspconfig").setup { ensure_installed = _G.lsp_servers }
