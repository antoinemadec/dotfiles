gruvbox_colors = {
  ['light4'] = '#a89984',
  ['neutral_green'] = '#98971a',
  ['yellow'] = '#fabd2f',
  ['faded_aqua'] = '#427b58',
  ['bright_blue'] = '#83a598',
  ['orange'] = '#fe8019',
  ['neutral_blue'] = '#458588',
  ['purple'] = '#d3869b',
  ['faded_green'] = '#79740e',
  ['neutral_red'] = '#cc241d',
  ['gray_244'] = '#928374',
  ['gray_245'] = '#928374',
  ['bright_yellow'] = '#fabd2f',
  ['fg4_256'] = '#a89984',
  ['fg0'] = '#fbf1c7',
  ['fg1'] = '#ebdbb1',
  ['fg2'] = '#d5c4a1',
  ['fg3'] = '#bdae93',
  ['fg4'] = '#a89984',
  ['bright_purple'] = '#d3869b',
  ['neutral_orange'] = '#d65d0e',
  ['bright_orange'] = '#fe8019',
  ['faded_red'] = '#9d0006',
  ['light0_soft'] = '#f2e5bc',
  ['blue'] = '#83a598',
  ['faded_blue'] = '#076678',
  ['light0_hard'] = '#f9f5d7',
  ['bright_green'] = '#b8bb26',
  ['gray'] = '#928374',
  ['dark4_256'] = '#7c6f64',
  ['neutral_purple'] = '#b16286',
  ['dark0'] = '#282828',
  ['dark1'] = '#3c3836',
  ['dark2'] = '#504945',
  ['dark3'] = '#665c54',
  ['dark4'] = '#7c6f64',
  ['dark0_soft'] = '#32302f',
  ['bright_aqua'] = '#8ec07c',
  ['neutral_aqua'] = '#689d6a',
  ['dark0_hard'] = '#1d2021',
  ['light4_256'] = '#a89984',
  ['green'] = '#b8bb26',
  ['neutral_yellow'] = '#d79921',
  ['aqua'] = '#8ec07c',
  ['faded_yellow'] = '#b57614',
  ['red'] = '#fb4934',
  ['faded_purple'] = '#8f3f71',
  ['bg0'] = '#32302f',
  ['bg1'] = '#3c3836',
  ['bg2'] = '#504945',
  ['bg3'] = '#665c54',
  ['bg4'] = '#7c6f64',
  ['bright_red'] = '#fb4934',
  ['faded_orange'] = '#af3a03',
  ['light0'] = '#fbf1c7',
  ['light1'] = '#ebdbb1',
  ['light2'] = '#d5c4a1',
  ['light3'] = '#bdae93'
}


function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end


function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end


function gruvbox_replace_text(text)
  local avg_bg_file = os.getenv('HOME') .. '/.config/i3/wallpaper/avg_val_top_left.txt'
  if file_exists(avg_bg_file) then
    avg = lines_from(avg_bg_file)
    avg_nb = tonumber(avg[1])
    if avg_nb and avg_nb > 100 then
      text = string.gsub(text, '{gruvbox fg', '{gruvbox bg')
    end
  end
  return string.gsub(text, '{gruvbox ([^}]*)}', gruvbox_replace_text_core)
end


function gruvbox_replace_text_core(color_name)
  return '{color ' .. string.sub(gruvbox_colors[color_name], 2) .. '}'
end
