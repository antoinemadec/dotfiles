return {
  cmd = { "clangd", "--offset-encoding=utf-16" },
  filetypes = { 'c', 'cpp' },
  root_markers = { '.clangd', 'compile_commands.json' },
}
