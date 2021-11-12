local background = vim.opt.background:get()
local configuration = vim.fn['gruvbox_material#get_configuration']()
local palette = vim.fn['gruvbox_material#get_palette'](background, configuration.palette)


-- statusline
vim.cmd([[
autocmd CursorHold,CursorHoldI * call UpdateCurrentTag()

function UpdateCurrentTag()
  if !exists('g:tagbar_stl_' . &ft)
    return
  endif
  let b:stl_current_tag =  tagbar#currenttagtype('[%s]', '') . tagbar#currenttag(' %s', '')
endfunction
]])

local function get_function_name()
  return vim.b.coc_current_function or vim.b.stl_current_tag or ''
end

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    section_separators = '',
    component_separators = '',
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch',
      {
        'diff',
        diff_color = {
          added    = {fg = palette.green[1]},
          modified = {fg = palette.blue[1]},
          removed  = {fg = palette.red[1]},
        },
      },
      {
        'g:coc_status',
        color = {bg = palette.bg_visual_blue[1]}
      },
      {
        get_function_name,
        color = {bg = palette.bg_visual_blue[1]}
      },
      {
        'diagnostics',
        sources = {'nvim_lsp', 'coc'},
        diagnostics_color = {
          error = {bg = palette.red[1]    , fg = palette.bg0[1]},
          warn  = {bg = palette.yellow[1] , fg = palette.bg0[1]},
          info  = {bg = palette.blue[1]   , fg = palette.bg0[1]},
          hint  = {bg = palette.aqua[1]   , fg = palette.bg0[1]},
        },
      }
    },
    lualine_c = {{
        'filename',
        path = 1 -- relative path
    }},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fugitive', 'quickfix'}
}


-- tabline
vim.cmd([[
function! Tabline() abort
    let l:line = ''
    let l:current = tabpagenr()
    for l:i in range(1, tabpagenr('$'))
        if l:i == l:current
            let l:line .= '%#TabLineSel#'
        else
            let l:line .= '%#TabLine#'
        endif
        let l:label = fnamemodify(
            \ bufname(tabpagebuflist(l:i)[tabpagewinnr(l:i) - 1]),
            \ ':t'
        \ )
        let l:line .= '%' . i . 'T' " Starts mouse click target region.
        let l:line .= '  ' . l:label . '  '
    endfor
    let l:line .= '%#TabLineFill#'
    let l:line .= '%T' " Ends mouse click target region(s).
    return l:line
endfunction

set tabline=%!Tabline()
]])
