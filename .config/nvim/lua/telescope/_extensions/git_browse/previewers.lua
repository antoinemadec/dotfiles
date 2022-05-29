local M = {}
local conf = require("telescope.config").values
local previewers = require "telescope.previewers"
local putils = require "telescope.previewers.utils"
local utils = require "telescope.utils"

local git_preview_command = { 'git', '--no-pager', 'show', '--no-color', '--pretty' }

local function defaulter(f, default_opts)
  default_opts = default_opts or {}
  return {
    new = function(opts)
      if conf.preview == false and not opts.preview then
        return false
      end
      opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
      if type(conf.preview) == "table" then
        for k, v in pairs(conf.preview) do
          opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
        end
      end
      return f(opts)
    end,
    __call = function()
      local ok, err = pcall(f(default_opts))
      if not ok then
        error(debug.traceback(err))
      end
    end,
  }
end

local search_teardown = function(self)
  if self.state and self.state.hl_id then
    pcall(vim.fn.matchdelete, self.state.hl_id, self.state.hl_win)
    self.state.hl_id = nil
  end
end

local search_cb_jump = function(self, bufnr, query)
  if not query then
    return
  end
  vim.api.nvim_buf_call(bufnr, function()
    pcall(vim.fn.matchdelete, self.state.hl_id, self.state.winid)
    vim.cmd "norm! gg"
    vim.fn.search(query, "W")
    vim.cmd "norm! zz"

    self.state.hl_id = vim.fn.matchadd("TelescopePreviewMatch", query)
  end)
end

M.git_commit_diff_to_parent = defaulter(function(opts)
  local cmd = utils.get_default(opts.git_preview_command, git_preview_command)
  return previewers.new_buffer_previewer {
    title = "Git Diff to Parent Preview",
    teardown = search_teardown,
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      local full_cmd = vim.tbl_flatten({cmd, entry.value})
      if opts.current_file then
        table.insert(full_cmd, "--")
        table.insert(full_cmd, opts.current_file)
      end

      putils.job_maker(full_cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          search_cb_jump(self, bufnr, opts.current_line)
        end,
      })
      putils.regex_highlighter(self.state.bufnr, "diff")
    end,
  }
end, {})

return M
