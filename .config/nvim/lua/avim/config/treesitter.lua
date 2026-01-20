local ts_languages = {
  'bash',
  'cpp',
  'cmake',
  'lua',
  'make',
  'python',
  'query',
  'regex',
  'rust',
  'systemverilog',
  'vhdl',
  'vim',
  'vimdoc',
}

vim.filetype.add({
  extension = {
    v = 'systemverilog',
    svh = 'systemverilog',
    sv = 'systemverilog',
  }
})

vim.treesitter.language.register('bash', { 'sh' })

local is_old_nvim_treesitter, old_nvim_treesitter = pcall(require, 'nvim-treesitter.configs')

if is_old_nvim_treesitter then
  local function disable(lang, bufnr)
    return _G.is_large_file(bufnr)
  end

  for index, value in ipairs(ts_languages) do
    if value == "systemverilog" then
      ts_languages[index] = "verilog"
    end
  end

  ---@diagnostic disable: missing-fields
  old_nvim_treesitter.setup({
    ensure_installed = ts_languages,
    highlight = {
      enable = true,
      disable = disable,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = false,
      disable = disable,
    },
  })
else
  require('nvim-treesitter').install(ts_languages)

  local ts_filetypes = {}
  for _, lang in ipairs(ts_languages) do
    local fts = vim.treesitter.language.get_filetypes(lang)
    for _, ft in ipairs(fts) do
      if not vim.tbl_contains(ts_filetypes, ft) then
        table.insert(ts_filetypes, ft)
      end
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    pattern = ts_filetypes,
    callback = function(ev)
      if _G.is_large_file(ev.buf) then
        return
      end
      vim.treesitter.start()
    end,
  })
end
