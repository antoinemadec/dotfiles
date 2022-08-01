local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')


-- CR handling with coc.nvim
npairs.setup({ map_cr = false })

_G.MUtils.completion_confirm = function()
  if vim.fn['coc#pum#visible']() ~= 0 then
    return vim.fn['coc#_select_confirm']()
  else
    return npairs.autopairs_cr()
  end
end

remap('i', '<CR>', 'v:lua.MUtils.completion_confirm()', { expr = true, noremap = true })


-- custom rules
npairs.remove_rule('`')
npairs.add_rule(Rule('`', '`', "-verilog_systemverilog"))
npairs.remove_rule("'")
npairs.add_rule(Rule("'", "'", "-verilog_systemverilog"))
