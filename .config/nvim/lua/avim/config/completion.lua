-- luasnip
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.filetype_extend("verilog_systemverilog", { "systemverilog" })

-- nvim-cmp
local cmp = require 'cmp'
local cmp_kinds = {
  Text = '  ',
  Method = '  ',
  Function = '  ',
  Constructor = '  ',
  Field = '  ',
  Variable = '  ',
  Class = '  ',
  Interface = '  ',
  Module = '  ',
  Property = '  ',
  Unit = '  ',
  Value = '  ',
  Enum = '  ',
  Keyword = '  ',
  Snippet = '  ',
  Color = '  ',
  File = '  ',
  Reference = '  ',
  Folder = '  ',
  EnumMember = '  ',
  Constant = '  ',
  Struct = '  ',
  Event = '  ',
  Operator = '  ',
  TypeParameter = '  ',
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
      vim_item.kind = (cmp_kinds[vim_item.kind] or vim_item.kind) .. string.sub(vim_item.kind, 1, 3)
      vim_item.menu = ({
        luasnip = "[snip]",
        nvim_lsp = "[lsp]",
        path = "[path]",
        buffer = "[buf]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },
}

vim.api.nvim_set_hl(0, 'CmpItemMenu', { link = 'Grey', default = false })
