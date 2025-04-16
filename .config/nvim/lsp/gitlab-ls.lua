local url = os.getenv("GITLAB_URL")
local private_token = os.getenv("GITLAB_API_TOKEN")
local projects = { os.getenv("GITLAB_PROJECTS") }

if not url or not private_token or #projects == 0 then
  return {}
end

return {
  cmd = { vim.fn.stdpath("data") .. '/lazy/gitlab-ls/gitlab-ls.sh' },
  filetypes = { 'txt', 'indentcolor' },
  init_options = {
    url = url,
    private_token = private_token,
    projects = projects,
  },
  on_attach = function(client, bufnr)
    local diagnostic_ns = vim.lsp.diagnostic.get_namespace(client.id, true)
    vim.diagnostic.config({
      signs = false,
      underline = false,
      virtual_lines = false,
      virtual_text = true,
    }, diagnostic_ns)

  end,
}
