-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/antoine/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/antoine/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/antoine/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/antoine/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/antoine/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  ["asyncrun.vim"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/asyncrun.vim",
    url = "https://github.com/skywind3000/asyncrun.vim"
  },
  ["coc-fzf"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/coc-fzf",
    url = "https://github.com/antoinemadec/coc-fzf"
  },
  ["coc.nvim"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/coc.nvim",
    url = "https://github.com/neoclide/coc.nvim"
  },
  fzf = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gruvbox-material"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/gruvbox-material",
    url = "https://github.com/sainnhe/gruvbox-material"
  },
  indentline = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/indentline",
    url = "https://github.com/yggdroot/indentline"
  },
  ["lightline.vim"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/lightline.vim",
    url = "https://github.com/itchyny/lightline.vim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  tagbar = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/tagbar",
    url = "https://github.com/preservim/tagbar"
  },
  ["verilog_systemverilog.vim"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/verilog_systemverilog.vim",
    url = "https://github.com/vhda/verilog_systemverilog.vim"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-highlight-groups"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-highlight-groups",
    url = "https://github.com/antoinemadec/vim-highlight-groups"
  },
  ["vim-illuminate"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-illuminate",
    url = "https://github.com/RRethy/vim-illuminate"
  },
  ["vim-indentcolor-filetype"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-indentcolor-filetype",
    url = "https://github.com/antoinemadec/vim-indentcolor-filetype"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-polyglot",
    url = "https://github.com/sheerun/vim-polyglot"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-sensible",
    url = "https://github.com/tpope/vim-sensible"
  },
  ["vim-sneak"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-sneak",
    url = "https://github.com/justinmk/vim-sneak"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["vim-speeddating"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-speeddating",
    url = "https://github.com/tpope/vim-speeddating"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-startify",
    url = "https://github.com/mhinz/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-textobj-indent"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-textobj-indent",
    url = "https://github.com/kana/vim-textobj-indent"
  },
  ["vim-textobj-line"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-textobj-line",
    url = "https://github.com/kana/vim-textobj-line"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-textobj-user",
    url = "https://github.com/kana/vim-textobj-user"
  },
  ["vim-verilog-instance"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-verilog-instance",
    url = "https://github.com/antoinemadec/vim-verilog-instance"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-visual-multi",
    url = "https://github.com/mg979/vim-visual-multi"
  },
  ["vim-which-key"] = {
    loaded = true,
    path = "/home/antoine/.local/share/nvim/site/pack/packer/start/vim-which-key",
    url = "https://github.com/liuchengxu/vim-which-key"
  }
}

time([[Defining packer_plugins]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
