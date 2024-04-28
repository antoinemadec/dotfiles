require("mason").setup({
  PATH = "skip", -- taken care of in lsp.lua
})

local function install_package(package_name)
  if not require("mason-registry").is_installed(package_name) then
    vim.cmd("MasonInstall " .. package_name)
  end
end

-- install lsp servers
local server_to_package = {
  ["bashls"] = "bash-language-server",
  ["lua_ls"] = "lua-language-server",
  ["rust_analyzer"] = "rust-analyzer",
  ["tsserver"] = "typescript-language-server",
}

for _, server in ipairs(_G.lsp_servers) do
  local package_name = server_to_package[server] or server
  install_package(package_name)
end

-- install other
for _, package_name in ipairs({
  "black",
}) do
  install_package(package_name)
end
