local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

npairs.setup()

-- -- nvim-cmp support
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- local cmp = require('cmp')
-- cmp.event:on(
--   'confirm_done',
--   cmp_autopairs.on_confirm_done()
-- )

-- custom rules
npairs.remove_rule('`')
npairs.add_rule(Rule('`', '`', "-verilog_systemverilog"))
npairs.remove_rule("'")
npairs.add_rule(Rule("'", "'", { "-verilog_systemverilog", "-indentcolor" }))
