dofile(os.getenv('HOME') .. '/.config/conky/gruvbox.lua')

conky.config = {
    alignment = 'top_right',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=12',
    gap_x = 30,
    gap_y = 160,
    minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
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
    update_interval = 2.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
}

text = [[
${gruvbox fg4}RAM Usage:${gruvbox fg0} $mem/$memmax - $memperc% ${membar 4}
${gruvbox fg4}Swap Usage:${gruvbox fg0} $swap/$swapmax - $swapperc% ${swapbar 4}
${gruvbox fg4}CPU Usage:${gruvbox fg0} $cpu% ${cpubar 4}
${gruvbox fg4}Processes:${gruvbox fg0} $processes  ${gruvbox fg4}Running:${gruvbox fg0} $running_processes
$hr
${gruvbox fg4}File systems:
 / ${gruvbox fg0}${fs_used /}/${fs_size /} ${fs_bar 6 /}
${gruvbox fg4}Networking:
Up:${gruvbox fg0} ${upspeed} ${gruvbox fg4} - Down:${gruvbox fg0} ${downspeed}
$hr
${gruvbox fg4}Name              PID     CPU%   MEM%
${gruvbox fg2} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${gruvbox fg2} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${gruvbox fg2} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${gruvbox fg2} ${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
]]

conky.text = gruvbox_replace_text(text)
