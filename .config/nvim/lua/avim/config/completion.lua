-- luasnip
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.filetype_extend("verilog_systemverilog", { "systemverilog" })

-- AI
-- local cmp_ai = require('cmp_ai.config')
--
-- cmp_ai:setup({
--   max_lines = 100,
--   provider = 'Ollama',
--   provider_options = {
--     model = 'mistral_dev',
--   },
--   notify = true,
--   notify_callback = function(msg)
--     vim.notify(msg)
--   end,
--   run_on_every_keystroke = true,
--   ignored_file_types = {
--     -- default is not to ignore
--     -- uncomment to ignore in lua:
--     -- lua = true
--   },
-- })

-- nvim-cmp
local cmp = require 'cmp'
local cmp_kinds = {
  Array         = " ",
  Boolean       = "󰨙 ",
  Class         = " ",
  Codeium       = "󰘦 ",
  Color         = " ",
  Control       = " ",
  Collapsed     = " ",
  Constant      = "󰏿 ",
  Constructor   = " ",
  Copilot       = " ",
  Enum          = " ",
  EnumMember    = " ",
  Event         = " ",
  Field         = " ",
  File          = " ",
  Folder        = " ",
  Function      = "󰊕 ",
  Interface     = " ",
  Key           = " ",
  Keyword       = " ",
  Method        = "󰊕 ",
  Module        = " ",
  Namespace     = "󰦮 ",
  Null          = " ",
  Number        = "󰎠 ",
  Object        = " ",
  Operator      = " ",
  Package       = " ",
  Property      = " ",
  Reference     = " ",
  Snippet       = " ",
  String        = " ",
  Struct        = "󰆼 ",
  TabNine       = "󰏚 ",
  Text          = " ",
  TypeParameter = " ",
  Unit          = " ",
  Value         = " ",
  Variable      = "󰀫 ",
}
local function remap_cmp_snip_next()
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end, { 'i', 's' })
end
local function remap_cmp_snip_prev()
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.expand_or_jumpable(-1) then
      luasnip.expand_or_jump(-1)
    else
      fallback()
    end
  end, { 'i', 's' })
end

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<C-j>'] = remap_cmp_snip_next(),
    ['<C-k>'] = remap_cmp_snip_prev(),
    ['<C-l>'] = cmp.mapping.close(),
    ['<Tab>'] = remap_cmp_snip_next(),
    ['<S-Tab>'] = remap_cmp_snip_prev(),
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = (cmp_kinds[vim_item.kind] or vim_item.kind) .. string.lower(string.sub(vim_item.kind, 1, 3))
      vim_item.menu = ({
        luasnip = "snip",
        nvim_lsp = "lsp",
        path = "path",
        buffer = "buf",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    -- { name = 'comp_ai'},
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local buf_list = {}
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_line_count(bufnr) < vim.g.large_file_cutoff then
              table.insert(buf_list, bufnr)
            end
          end
          return buf_list
        end
      },
    },
  },
}

vim.api.nvim_set_hl(0, 'CmpItemMenu', { link = 'Grey', default = false })
