vim.g.startify_change_to_dir = 0

local emojis = { '🖥', '🌞', '💫', '🤖', '🤯', '💓', '💥', '😻', '🖖', '👀', '🌍', '🔭', '💾' }
local function get_emojis(number)
  local e = {}
  math.randomseed(os.time())
  for _ = 1, number do
    local n = math.random(1, #emojis)
    table.insert(e, emojis[n])
    table.remove(emojis, n)
  end
  return table.concat(e)
end

vim.g.startify_custom_header = { '   🇳🇻🇮🇲 ' .. get_emojis(3) }

vim.g.startify_commands = {
  { s = { 'scratch buffer', ':Scratch tab' } },
  { c = { 'plugin clean', 'lua StartifyPluginClean()' } },
  { u = { 'plugin update', 'lua StartifyPluginUpdate()' } },
}

vim.g.startify_lists = {
  { type = 'commands' },
  { type = 'dir', header = { '   MRU ' .. vim.fn.getcwd() } },
  { type = 'sessions', header = { '   Sessions' } },
  { type = 'bookmarks', header = { '   Bookmarks' } },
}

function _G.StartifyPluginClean()
  vim.cmd('Lazy clean')
end

function _G.StartifyPluginUpdate()
  vim.cmd([[
  Lazy! sync
  MasonToolsUpdate
  CocUpdate
  ]])
end
