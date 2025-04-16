return {
  cmd = { vim.fn.stdpath("data") .. '/lazy/gitlab-ls/gitlab-ls.sh' },
  filetypes = { 'txt', 'indentcolor' },
  init_options = {
    url = os.getenv("GITLAB_URL"),
    private_token = os.getenv("GITLAB_API_TOKEN"),
    projects = { os.getenv("GITLAB_PROJECTS") },
  },
}
