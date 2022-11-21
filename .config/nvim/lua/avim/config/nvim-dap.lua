-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
local dap, dapui = require("dap"), require("dapui")
local dap_utils = _G.DUtils


-- adapters
dap.adapters.python = {
  type = 'executable',
  command = 'debugpy-adapter',
  args = {},
}
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'OpenDebugAD7',
  args = {},
}


-- configurations
local function get_args(reuse_previous)
  if not reuse_previous then
    vim.g.dap_args = dap_utils.input_args()
  end
  dap_utils.notify_args(vim.g.dap_args)
  return vim.g.dap_args
end

local python_default_conf = {
  type = 'python',
  request = 'launch',
  name = "Launch file",
  program = "${file}",
  pythonPath = '/usr/bin/python',
  console = 'integratedTerminal',
}
dap.configurations.python = {
  python_default_conf,
  vim.tbl_extend('force', python_default_conf,
    {
      name = "Launch file with args",
      args = function() return get_args(false) end
    }
  ),
  vim.tbl_extend('force', python_default_conf,
    {
      name = "Launch file with previous args",
      args = function() return get_args(true) end
    }
  ),
}

local cpp_default_conf = {
  name = "Launch file",
  type = "cppdbg",
  request = "launch",
  program = function()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  end,
  cwd = '${workspaceFolder}',
  stopAtEntry = true,
  text = '-enable-pretty-printing',
  description = 'enable pretty printing',
  ignoreFailures = false,
}
dap.configurations.cpp = {
  cpp_default_conf,
  vim.tbl_extend('force', cpp_default_conf,
    {
      name = "Launch file with args",
      args = function() return get_args(false) end
    }
  ),
  vim.tbl_extend('force', cpp_default_conf,
    {
      name = "Launch file with previous args",
      args = function() return get_args(true) end
    }
  )
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp


-- UI
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '❓', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = '', linehl = '', numhl = '' })

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
