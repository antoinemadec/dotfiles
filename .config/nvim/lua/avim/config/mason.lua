require("mason").setup({
  PATH = "skip", -- taken care of in lsp.lua
})

-- ensure installed: LSP
require("mason-lspconfig").setup { ensure_installed = _G.lsp_servers }

-- ensure installed: other
local non_lsp_mason_packages = {"black"}

local mason_registry = require("mason-registry")
for _,package_name in ipairs(non_lsp_mason_packages) do
  if not mason_registry.is_installed(package_name) then
    vim.cmd("MasonInstall " .. package_name)
  end
end
