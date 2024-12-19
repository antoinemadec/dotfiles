-- disable some plugins/options when file is too big
vim.g.large_file_cutoff = 10000

-- profile lua funcitons
--  startup: NVIM_PROFILE=start nvim
--  runtime: NVIM_PROFILE=1 nvim
local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  vim.o.runtimepath = vim.fn.stdpath("data") .. "/lazy/profile.nvim," .. vim.o.runtimepath
  require("profile").instrument_autocmds()
  if should_profile:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
end

require('avim.utils')
require('avim.floaterm')
require('avim.options')
require('avim.plugins')
require('avim.mappings')
require('avim.misc_vim')

-- profile mapping on <f1>
if should_profile then
  local function toggle_profile()
    local prof = require("profile")
    if prof.is_recording() then
      prof.stop()
      vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
        if filename then
          prof.export(filename)
          vim.notify(string.format("Wrote %s", filename))
        end
      end)
    else
      prof.start("*")
    end
  end
  vim.keymap.set("", "<f1>", toggle_profile)
end
