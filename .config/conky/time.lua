dofile(os.getenv('HOME') .. '/.config/conky/gruvbox.lua')

conky.config = {
    alignment = 'top_right',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = false,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=12',
    gap_x = -100,
    gap_y = 20,
    minimum_height = 150,
    minimum_width = 5,
    net_avg_samples = 1,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window_class = 'Conky',
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    own_window_transparent = true,
    own_window = true,
    own_window_type = 'override',
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
    xftalpha = 0.1,
}

text = [[
${voffset 40}${gruvbox fg0}${font GE Inspira:pixelsize=70}${time %I:%M}${font}${voffset -45}${offset 10}${gruvbox neutral_green}${font GE Inspira:pixelsize=30}${time %d} ${voffset -5}${gruvbox neutral_yellow}${font GE Inspira:pixelsize=20}${time  %B} ${time %Y}${gruvbox neutral_red}${font}${voffset 24}${offset -205}${font GE Inspira:pixelsize=30}${time %A}${font}
]]

conky.text = gruvbox_replace_text(text)
