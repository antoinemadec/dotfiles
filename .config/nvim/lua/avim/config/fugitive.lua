local a = vim.api

a.nvim_create_autocmd('User', {
  pattern = 'FugitiveIndex',
  command = 'nnoremap <buffer> . :Git difftool -y<cr>'
})

function _G.ToggleGstatus ()
  local tabs = a.nvim_list_tabpages()
  local gs_tab = nil
  for _, tab in ipairs(tabs) do
    local ok, tabname = pcall(a.nvim_tabpage_get_var, tab, 'tabname')
    if ok and tabname == 'git_status' then
      gs_tab = tab
      break
    end
  end
  if gs_tab then
    if gs_tab == a.nvim_get_current_tabpage() then
      -- git_status is current tab: close it
      vim.cmd('tabclose')
    else
      -- git_status is not current tab: jump
      vim.cmd('tabn ' .. a.nvim_tabpage_get_number(gs_tab))
    end
  else
    -- git_status does not exist: create it
    vim.cmd([[
    Gtabedit :
    set previewwindow
    ]])
    a.nvim_tabpage_set_var(0, 'tabname', 'git_status')
  end
end
