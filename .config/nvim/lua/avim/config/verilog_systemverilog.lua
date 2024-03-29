local M = {}

function M.setup()
  vim.filetype.add({
    extension = {
      v = 'verilog_systemverilog',
      svh = 'verilog_systemverilog',
      sv = 'verilog_systemverilog',
    }
  })
end

function M.config()
  vim.g.verilog_disable_indent_lst = "eos"
  vim.g.verilog_instance_skip_last_coma = 1

  vim.g.tagbar_type_verilog_systemverilog = {
    ctagstype = 'SystemVerilog',
    kinds = { 'b:blocks:0:1',
    'f:functions:0:1',
    'i:instances:1:1',
    'm:modules:0:1',
    't:tasks:0:1',
    'A:assertions:1:0',
    'C:classes:0:1',
    'V:covergroups:0:1',
    'I:interfaces:0:1',
    'L:clocking blocks:1:0',
    'M:modport:1:0',
    'K:packages:0:1',
    'P:programs:0:1',
    'R:properties:0:0',
    'T:typedefs:1:0'
  },
  sro = '.',
  kind2scope = {
    b = 'block',
    f = 'function',
    m = 'module',
    t = 'task',
    C = 'class',
    V = 'covergroup',
    I = 'interface',
    K = 'package',
    P = 'program',
    R = 'property'
  }
}
end

return M
