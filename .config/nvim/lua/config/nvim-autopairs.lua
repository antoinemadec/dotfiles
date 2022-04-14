local remap = vim.api.nvim_set_keymap
local t = _G.MUtils.t
local npairs = require('nvim-autopairs')
npairs.setup({map_cr=false})

_G.MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    return t"<C-y>"
  else
    return npairs.autopairs_cr()
  end
end

remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
