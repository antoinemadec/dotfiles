if tonumber(os.getenv("TERM_COLORS")) >= 256 then
  vim.o.termguicolors = true
end

require('avim.utils')
require('avim.plugins')
require('avim.options')
require('avim.mappings')
require('avim.misc_vim')
