local servers = {
  'clangd',
  'bashls',
  'lua_ls',
  'rust_analyzer',
  'pyright',
  'tsserver'
}

-- lspconfig
local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

require("mason").setup()
require("mason-lspconfig").setup { ensure_installed = servers }

local function on_attach(client, _)
  lsp_status.on_attach(client)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function get_lsp_settings(lsp_server)
  if lsp_server == "lua_ls" then
    local nvim_runtime_dirs = vim.api.nvim_get_runtime_file("", true)
    -- remove .configs path to avoid duplicate with dotfiles/.config
    local i = 1
    while (i <= #nvim_runtime_dirs) do
        if string.find(nvim_runtime_dirs[i], '/.config/') then
            table.remove(nvim_runtime_dirs, i)
        else
            i = i + 1
        end
    end
    return {
      Lua = {
        runtime = { version = "LuaJIT", },
        diagnostics = { globals = { "vim" }, },
        workspace = { library = nvim_runtime_dirs, },
        telemetry = { enable = false, },
      },
    }
  end
  return {}
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = get_lsp_settings(lsp),
  }
end

-- luasnip
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()

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

-- diagnostics
local signs = { Error = ">>", Warn = ">>", Hint = ">>", Info = ">>" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local lsp_virtual_text = true
function _G.ToggleLspVirtualText()
  lsp_virtual_text = not lsp_virtual_text
  vim.diagnostic.config({ virtual_text = lsp_virtual_text })
end

ToggleLspVirtualText()
