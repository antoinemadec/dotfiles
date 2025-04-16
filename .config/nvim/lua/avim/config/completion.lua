local source_to_short_name = {
  Buffer = "buf",
}
setmetatable(source_to_short_name, {
  __index = function(table, key)
    return string.lower(string.sub(key, 1, 4))
  end
})

require("blink-cmp").setup(
  {
    enabled = function() return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false and _G.is_large_file() ~= true end,

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

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lsp = { fallbacks = {} }, -- avoid blocking buffer suggestions
        snippets = {
          opts = {
            extended_filetypes = {
              verilog_systemverilog = { 'systemverilog' },
            },
          }
        },
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
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },

    signature = { enabled = true },

    cmdline = {
      enabled = true,
      completion = {
        menu = { auto_show = false },
        list = {
          selection = {
            auto_insert = true,
            preselect = false,
          }
        },
      },
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        update_delay_ms = 50,
      },
      list = {
        selection = {
          auto_insert = true,
          preselect = false,
        }
      },
      menu = {
        draw = {
          columns = { { 'label' }, { 'kind_icon_and_name' }, { 'source_name_short' }, },
          components = {
            kind_icon_and_name = {
              ellipsis = false,
              text = function(ctx)
                return _G.LUtils.get_kind_labels(ctx.kind) .. ctx.icon_gap .. string.lower(string.sub(ctx.kind, 1, 3))
              end,
              highlight = function(ctx) return ctx.kind_hl end,
            },
            source_name_short = {
              width = { max = 30 },
              text = function(ctx) return source_to_short_name[ctx.source_name] end,
              highlight = 'Grey',
            },
            label = {
              width = { fill = true, max = 60 },
              text = function(ctx) return ctx.label .. ctx.label_detail end,
              highlight = function(ctx)
                -- label and label details
                local label = ctx.label
                local highlights = {
                  { 0, #label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                }
                if ctx.label_detail then
                  table.insert(highlights, { #label, #label + #ctx.label_detail, group = 'Grey' })
                end

                if vim.list_contains(ctx.self.treesitter, ctx.source_id) and not ctx.deprecated then
                  -- add treesitter highlights
                  vim.list_extend(highlights, require('blink.cmp.completion.windows.render.treesitter').highlight(ctx))
                end

                -- characters matched on the label by the fuzzy matcher
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end

                return highlights
              end,
            },
          }
        },
      }
    }
  }
)
