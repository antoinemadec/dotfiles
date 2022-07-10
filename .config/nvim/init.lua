local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
  impatient.enable_profile()
end

require('utils')
require('plugins')
if (packer_bootstrap) then
  return
end
require('options')
require('mappings')
require('misc_vim')
