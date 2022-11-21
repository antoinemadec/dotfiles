local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')


-- CR handling with coc.nvim
npairs.setup({ map_cr = false })

_G.MUtils.completion_confirm = function()
  if vim.fn['coc#pum#visible']() ~= 0 then
    local pum_info = vim.fn['coc#pum#info']()
    if pum_info['index'] ~= -1  then
      return vim.fn['coc#pum#confirm']()
    end
  end
  return npairs.autopairs_cr()
end

remap('i', '<CR>', 'v:lua.MUtils.completion_confirm()', { expr = true, noremap = true })


-- custom rules
npairs.remove_rule('`')
npairs.add_rule(Rule('`', '`', "-verilog_systemverilog"))
npairs.remove_rule("'")
npairs.add_rule(Rule("'", "'", {"-verilog_systemverilog", "-indentcolor"}))
