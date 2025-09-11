if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = 1

local function jump_in_verilog_module(follow_port)
  local ts = require("avim.treesitter")
  local verilog_module_port = ts.verilog_return_module_and_port()
  if verilog_module_port.module == nil then
    vim.notify("not in a module instantiation", vim.log.levels.WARN)
    return
  end
  local ok, _ = pcall(vim.cmd, "tjump! " .. verilog_module_port.module)
  if not ok then
    vim.notify("Tag not found: " .. verilog_module_port.module, vim.log.levels.ERROR)
    return
  end
  if follow_port and verilog_module_port.port ~= nil then
    local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
    vim.api.nvim_feedkeys("/\\<" .. verilog_module_port.port .. "\\>" .. enter, 'n', false)
  end
end

vim.keymap.set("n", "<leader>i", function() jump_in_verilog_module() end, {
  buffer = true, desc = "verilog: jump in module" })

vim.keymap.set("n", "<leader>I", function() jump_in_verilog_module(true) end, {
  buffer = true, desc = "verilog: jump in module and follow port" })

local buf = vim.api.nvim_get_current_buf()
vim.bo[buf].tags = vim.o.tags .. ",~/.vim/tags/UVM_CDNS-1.2"
