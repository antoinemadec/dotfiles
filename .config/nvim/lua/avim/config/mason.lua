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
  ["gitlab-ls"] = "SKIP",
}

for _, server in ipairs(_G.lsp_servers) do
  local package_name = server_to_package[server] or server
  if package_name ~= "SKIP" then
    install_package(package_name)
  end
end

-- install other
for _, package_name in ipairs({
  "black",
}) do
  install_package(package_name)
end

-- update all packages
local M = {}

local function check_done(running_count, any_update)
    if running_count == 0 then
        if any_update then
            vim.notify('[mason-update-all] Finished updating all packages')
        else
            vim.notify('[mason-update-all] Nothing to update')
        end

        -- Trigger autocmd
        vim.schedule(function()
            vim.api.nvim_exec_autocmds('User', {
                pattern = 'MasonUpdateAllComplete',
            })
        end)
    end
end

function M.update_all()
  local any_update = false   -- Whether any package was updated
  local running_count = 0    -- Currently running jobs
  local done_launching_jobs = false
  local registry = require('mason-registry')

  vim.notify('[mason-update-all] Fetching updates')
  -- Update the registry
  registry.update(function(success, err)
    -- Iterate installed packages
    for _, pkg in ipairs(registry.get_installed_packages()) do
      running_count = running_count + 1

      -- Fetch for new version
      pkg:check_new_version(function(new_available, version)
        if new_available then
          any_update = true
          vim.notify(
            ('[mason-update-all] Updating %s from %s to %s'):format(
              pkg.name,
              version.current_version,
              version.latest_version
            )
          )
          pkg:install():on('closed', function()
            running_count = running_count - 1
            vim.notify(('[mason-update-all] Updated %s to %s'):format(pkg.name, version.latest_version))

            -- Done
            check_done(running_count, any_update)
          end)
        else
          running_count = running_count - 1
        end

        -- Done
        if done_launching_jobs then
          check_done(running_count, any_update)
        end
      end)
    end

    -- If all jobs are immediately done, do the checking here
    if running_count == 0 then
      check_done(running_count, any_update)
    end
    done_launching_jobs = true
  end)
end

return M
