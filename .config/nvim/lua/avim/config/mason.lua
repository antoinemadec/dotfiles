require("mason").setup()
require("mason-lspconfig").setup { ensure_installed = _G.lsp_servers }
