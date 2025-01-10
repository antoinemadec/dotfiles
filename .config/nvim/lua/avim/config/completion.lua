-- luasnip
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.filetype_extend("verilog_systemverilog", { "systemverilog" })

-- nvim-cmp
local cmp = require 'cmp'
local function remap_cmp_snip_next()
  return cmp.mapping(function(fallback)
    if luasnip.locally_jumpable(1) then
      luasnip.jump(1)
    elseif cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { 'i', 's' })
end
local function remap_cmp_snip_prev()
  return cmp.mapping(function(fallback)
    if luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
    elseif cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { 'i', 's' })
end

local cmp_confirm = cmp.mapping.confirm({
  behavior = cmp.ConfirmBehavior.Replace,
  select = false,
})

-- don't confirm for signature help to allow new line without selecting argument name
local confirm = cmp.sync(function(fallback)
  local e = cmp.core.view:get_selected_entry()
  if e and e.source.name == "nvim_lsp_signature_help" then
    fallback()
  else
    cmp_confirm(fallback)
  end
end)

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
    ['<CR>'] = confirm,
    ['<C-j>'] = remap_cmp_snip_next(),
    ['<C-k>'] = remap_cmp_snip_prev(),
    ['<C-l>'] = cmp.mapping.close(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = _G.LUtils.get_kind_labels(vim_item.kind) .. string.lower(string.sub(vim_item.kind, 1, 3))
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
