return {
  cmd = { vim.fn.stdpath("data") .. '/lazy/gitlab-ls/gitlab-ls.sh' },
  filetypes = { 'txt', 'indentcolor' },
  init_options = {
    url = os.getenv("GITLAB_URL"),
    private_token = os.getenv("GITLAB_API_TOKEN"),
    projects = { os.getenv("GITLAB_PROJECTS") },
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
