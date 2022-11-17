require("mason").setup()

require('mason-tool-installer').setup {
  ensure_installed = {
    'cpptools',
    'debugpy',
    'verible',
  },
  auto_update = false,
  run_on_start = false,
  start_delay = 3000,
}
