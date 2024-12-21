-- luasnip
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.filetype_extend("verilog_systemverilog", { "systemverilog" })

local source_to_short_name = {
  Buffer = "buf",
  Luasnip = "snip",
  mt = {
    __index = function(table, key)
      return string.lower(string.sub(key, 1, 4))
    end
  }
}
setmetatable(source_to_short_name, source_to_short_name.mt)

require("blink-cmp").setup(
  {
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },

      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_backward()
          else
            return cmp.select_prev()
          end
        end, 'select_prev', 'fallback' },
      ['<C-j>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_forward()
          else
            return cmp.select_next()
          end
        end, 'select_next', 'fallback' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    snippets = {
      expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction) require('luasnip').jump(direction) end,
    },

    sources = {
      default = { 'lsp', 'path', 'luasnip', 'buffer' },
      providers = {
        buffer = {
          name = 'Buffer',
          module = 'blink.cmp.sources.buffer',
          score_offset = -3,
          opts = {
            get_bufnrs = function()
              return vim
                  .iter(vim.api.nvim_list_wins())
                  :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                  :filter(function(buf) return vim.bo[buf].buftype ~= 'nofile' end)
                  :filter(function(buf) return vim.api.nvim_buf_line_count(buf) < vim.g.large_file_cutoff end)
                  :totable()
            end,
          }
        },
      },
    },

    signature = { enabled = true },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 50,
        -- Delay before updating the documentation window when selecting a new item,
        -- while an existing item is still visible
        update_delay_ms = 50,
      },
      list = {
        selection = "auto_insert"
      },
      menu = {
        draw = {
          treesitter = { 'lsp' },
          columns = { { 'label' }, { 'kind_icon_and_name' }, { 'source_name_short' } },
          components = {
            kind_icon_and_name = {
              ellipsis = false,
              text = function(ctx)
                return _G.LUtils.get_kind_labels(ctx.kind) .. ctx.icon_gap .. string.lower(string.sub(ctx.kind, 1, 3))
              end,
              highlight = function(ctx)
                return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind' .. ctx.kind
              end,
            },
            source_name_short = {
              width = { max = 30 },
              -- source_name or source_id are supported
              text = function(ctx)
                return source_to_short_name[ctx.source_name]
              end,
              highlight = 'Grey',
            },
          },
        },
      }
    }
  }
)
