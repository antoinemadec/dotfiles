local M = {}

local ts = vim.treesitter

function M.get_parent_with_type(node, type)
  if not node then return nil end

  local parent = node:parent()
  while parent and parent:type() ~= type do
    parent = parent:parent()
  end

  return parent
end

function M.get_child_with_name(node, name)
  if not node then return nil end

  for c_node, c_name in node:iter_children() do
    if c_name == name then
      return c_node
    end
  end

  return nil
end

---@class VerilogModulePort
---@field module? string?
---@field port? string?

--- Get the Verilog module and port name at the current cursor position.
--- @return VerilogModulePort
function M.verilog_return_module_and_port()
  -- Example of parsed tree nodes:
  --
  -- 1. .foo (foo),
  -- (named_port_connection ; [456, 8] - [456, 50]
  --   port_name: (simple_identifier) ; [456, 9] - [456, 25]
  --   connection: (expression ; [456, 26] - [456, 49]
  --     (primary ; [456, 26] - [456, 49]
  --       (hierarchical_identifier ; [456, 26] - [456, 46]
  --         (simple_identifier)) ; [456, 26] - [456, 46]
  --
  -- 2. .foo,
  -- (named_port_connection ; [456, 8] - [456, 25]
  --   port_name: (simple_identifier)) ; [456, 9] - [456, 25]

  local module_name_str = nil
  local port_name_str = nil

  local node = ts.get_node()
  if node then
    local module_instantiation = M.get_parent_with_type(node, "module_instantiation")
    local instance_type = M.get_child_with_name(module_instantiation, "instance_type")
    if instance_type then
      module_name_str = ts.get_node_text(instance_type, 0)
    end

    local port_connection = M.get_parent_with_type(node, "named_port_connection")
    if port_connection then
      local port_name = M.get_child_with_name(port_connection, "port_name")
      if port_name then
        port_name_str = ts.get_node_text(port_name, 0)
      end
    else
      port_name_str = vim.fn.expand("<cword>")
    end
  end

  return {
    module = module_name_str,
    port = port_name_str
  }
end

return M
