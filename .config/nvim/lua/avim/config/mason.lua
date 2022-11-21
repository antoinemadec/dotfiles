require("mason").setup()

require('mason-tool-installer').setup {
  ensure_installed = {
    'cpptools',
    'debugpy',
  },
  auto_update = false,
  run_on_start = false,
}
