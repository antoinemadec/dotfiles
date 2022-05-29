local M = {}

local utils = require "telescope.utils"

M.escape_chars = function(string)
  return string.gsub(string, "[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$|%.]", {
    ["\\"] = "\\\\",
    ["-"] = "\\-",
    ["("] = "\\(",
    [")"] = "\\)",
    ["["] = "\\[",
    ["]"] = "\\]",
    ["{"] = "\\{",
    ["}"] = "\\}",
    ["?"] = "\\?",
    ["+"] = "\\+",
    ["*"] = "\\*",
    ["^"] = "\\^",
    ["$"] = "\\$",
    ["."] = "\\.",
  })
end

local set_opts_cwd = function(opts)
  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  else
    opts.cwd = vim.loop.cwd()
  end

  -- Find root of git directory and remove trailing newline characters
  local git_root, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)
  local use_git_root = utils.get_default(opts.use_git_root, true)

  if ret ~= 0 then
    local in_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
    local in_bare = utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)

    if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
      error(opts.cwd .. " is not a git directory")
    elseif in_worktree[1] ~= "true" and in_bare[1] == "true" then
      opts.is_bare = true
    end
  else
    if use_git_root then
      opts.cwd = git_root[1]
    end
  end
end

function M.apply_checks(mod)
  for k, v in pairs(mod) do
    mod[k] = function(opts)
      opts = vim.F.if_nil(opts, {})

      set_opts_cwd(opts)
      v(opts)
    end
  end

  return mod
end

return M
