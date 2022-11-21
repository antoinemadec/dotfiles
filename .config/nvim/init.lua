local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
  impatient.enable_profile()
end

require('avim.utils')
require('avim.plugins')
if (packer_bootstrap) then
  return
end
require('avim.options')
require('avim.mappings')
require('avim.misc_vim')
