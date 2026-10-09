-- hyprland.lua
-- Native Hyprland 0.55+ Lua configuration.
-- Place at: ~/.config/hypr/hyprland.lua
-- Docs: https://wiki.hypr.land/Configuring/Start/

--------------------
---- MY PROGRAMS ----
--------------------

-- See https://wiki.hypr.land/Configuring/Basics/Keywords/
local terminal     = "__NV_PRIME_RENDER_OFFLOAD=0 alacritty"
local menu         = "rofi -show drun"
local menu_power   = "~/.config/i3/bin/rofi_power_menu"
local menu_ws      = "~/.config/hypr/bin/rofi_workspace"
local menu_window  = "~/.config/hypr/bin/rofi_window"
local menu_unicode = "~/.config/i3/bin/rofi_unicode"
local menu_accent  = "~/.config/i3/bin/rofi_accent"

local mainMod = "SUPER"  -- Sets "Windows" key as main modifier


--------------------
---- MONITORS ----
--------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "",   mode = "preferred", position = "auto", scale = "auto" })
hl.monitor({
    output   = "desc:LG Electronics LG HDR 4K 0x00031522",
    mode     = "3840x2160",
    position = "auto",
    scale    = 1.666667,
})

-- Per-machine layout saved by nwg-displays (~/.config/hypr/bin/displays), in
-- hyprlang syntax: "monitor=NAME,WxH@HZ,XxY,SCALE[,mirror,M][,bitdepth,10]",
-- "monitor=NAME,transform,T", "monitor=NAME,disable". Not tracked in git.
-- Loaded last so it takes precedence (the last matching rule wins).
local function load_monitors_conf(path)
    local f = io.open(path, "r")
    if not f then return end
    for line in f:lines() do
        local spec = line:match("^%s*monitor%s*=%s*(.-)%s*$")
        if spec then
            local fields = {}
            for field in (spec .. ","):gmatch("(.-),") do
                fields[#fields + 1] = field:match("^%s*(.-)%s*$")
            end
            local rule = { output = fields[1] }
            if fields[2] == "disable" then
                rule.disabled = true
            elseif fields[2] == "transform" then
                rule.transform = tonumber(fields[3])
            elseif fields[2] then
                rule.mode, rule.position, rule.scale = fields[2], fields[3], fields[4]
                for i = 5, #fields - 1, 2 do
                    if fields[i] == "mirror" then
                        rule.mirror = fields[i + 1]
                    elseif fields[i] == "bitdepth" then
                        rule.bitdepth = tonumber(fields[i + 1])
                    end
                end
            end
            hl.monitor(rule)
        end
    end
    f:close()
end
load_monitors_conf(os.getenv("HOME") .. "/.config/hypr/monitors.conf")


--------------------
---- AUTOSTART ----
--------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("~/.hyprland_startup.sh")

    -- tray applet
    hl.exec_cmd("nm-applet --indicator")

    -- screen sharing
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- authentication
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)

-- window previews for the window switcher (see menu_window)
local function capture_thumbnails()
    hl.exec_cmd("~/.config/hypr/bin/window_thumbnails")
end
hl.on("window.active", capture_thumbnails)
hl.on("workspace.active", capture_thumbnails)


-----------------------------
---- ENVIRONMENT VARIABLES ----
-----------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- Use NVIDIA GPU for rendering if available
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")

-- hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE",  "24")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 2,

        border_size = 2,

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types for info about colors
        col = {
            active_border   = "rgba(e2cca9ee)",  -- gruvbox material
            inactive_border = "rgba(665c54aa)",  -- gruvbox material gray
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before turning this on
        allow_tearing = false,

        layout = "dwindle",
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
    decoration = {
        rounding       = 5,
        rounding_power = 10,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        dim_inactive = true,
        dim_strength = 0.02,

        shadow = {
            enabled = false,
        },

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
        blur = {
            enabled = false,
        },
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
hl.config({
    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0,    0},    {1,    1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5,  0.5},  {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1,  1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true,  -- You probably want this
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#group
hl.config({
    group = {
        col = {
            -- border_active          = "rgba(ffffffff)",
            -- border_inactive        = "rgba(ffffffff)",
            border_active          = "rgba(e2cca9ee)",
            border_inactive        = "rgba(7c6f64aa)",
            border_locked_active   = "rgba(ffffffff)",
            border_locked_inactive = "rgba(ffffffff)",
        },
        groupbar = {
            gradients                = true,
            gradient_rounding        = 8,
            gradient_round_only_edges = false,
            font_size                = 13,
            col = {
                active   = "rgba(e2cca9ee)",
                inactive = "rgba(7c6f64aa)",
            },
            text_color          = "rgba(404946ee)",
            text_color_inactive = "rgba(e2cca9aa)",
            font_family         = "",
            indicator_height    = 0,
            keep_upper_gap      = false,
        },
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        repeat_delay = 150,
        repeat_rate  = 50,

        follow_mouse = 1,

        sensitivity = 0,  -- -1.0 - 1.0, 0 means no modification.

        special_fallthrough = true,

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- Menus
hl.bind(mainMod .. " + D",           hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + N",           hl.dsp.exec_cmd(menu_ws))
hl.bind(mainMod .. " + Tab",         hl.dsp.exec_cmd(menu_window))
hl.bind(mainMod .. " + SHIFT + E",   hl.dsp.exec_cmd(menu_power))
hl.bind(mainMod .. " + SHIFT + U",   hl.dsp.exec_cmd(menu_unicode))
hl.bind(mainMod .. " + SHIFT + A",   hl.dsp.exec_cmd(menu_accent))

-- Groups
-- Sort windows by layout position: left to right, then top to bottom
local function sort_by_position(windows)
    table.sort(windows, function(a, b)
        if a.at.x ~= b.at.x then return a.at.x < b.at.x end
        return a.at.y < b.at.y
    end)
    return windows
end

-- Dissolve the active group, laying its windows out in tab order
local function ungroup_in_order(active)
    local members = {}
    for _, w in ipairs(active.group.members) do
        table.insert(members, w)
    end
    hl.dispatch(hl.dsp.group.toggle())
    -- Swap windows into place, slot by slot
    for i, w in ipairs(members) do
        local occupant = sort_by_position({ table.unpack(members) })[i]
        if occupant.address ~= w.address then
            hl.dispatch(hl.dsp.window.swap({ window = w, target = occupant }))
        end
    end
    hl.dispatch(hl.dsp.focus({ window = active }))
end

-- Group all tiled windows of the workspace, keeping their layout order
local function group_all(ws, active)
    hl.dispatch(hl.dsp.group.toggle())
    local group = hl.get_active_window().group
    if not group then
        return
    end
    local tiled = {}
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
        if not w.floating then
            table.insert(tiled, w)
        end
    end
    for i, w in ipairs(sort_by_position(tiled)) do
        if w.address ~= active.address then
            group:add(w, i)
        end
    end
    hl.dispatch(hl.dsp.focus({ window = active }))
end

-- No group in workspace: group all tiled windows; otherwise: regular toggle
hl.bind(mainMod .. " + G", function()
    local ws = hl.get_active_workspace()
    local active = hl.get_active_window()
    if not ws or not active then
        hl.dispatch(hl.dsp.group.toggle())
    elseif active.group then
        ungroup_in_order(active)
    elseif (ws.groups or 0) == 0 and not active.floating then
        group_all(ws, active)
    else
        hl.dispatch(hl.dsp.group.toggle())
    end
end)

-- Terminals and apps
hl.bind(mainMod .. " + SHIFT + Return",       hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Return",               hl.dsp.exec_cmd(terminal .. " -e ssh $(cat ~/remote_machine.txt)"))
hl.bind(mainMod .. " + SHIFT + ALT + Return", hl.dsp.exec_cmd(terminal .. " -e ssh amadec@10.8.68.51"))
hl.bind(mainMod .. " + SHIFT + Q",            hl.dsp.window.close())
hl.bind(mainMod .. " + M",                    hl.dsp.exec_cmd("~/.config/hypr/bin/file_manager"))
hl.bind(mainMod .. " + T",                    hl.dsp.exec_cmd("~/.config/hypr/bin/vim_todo"))
hl.bind(mainMod .. " + C",                    hl.dsp.exec_cmd("~/.config/hypr/bin/calculator"))
hl.bind(mainMod .. " + semicolon",            hl.dsp.exec_cmd("~/axelera/jeanmich/interrupteur"))  -- Jean-Mich : lancer / pause / reprise
hl.bind("Print",                              hl.dsp.exec_cmd("~/.config/hypr/bin/screenshot.sh"))
hl.bind(mainMod .. " + Space",                hl.dsp.exec_cmd("~/.config/hypr/bin/toggle_focus_floating"))
hl.bind(mainMod .. " + SHIFT + Space",        hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",                    hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Focus / workspace navigation
hl.bind(mainMod .. " + P",             hl.dsp.focus({ last = true }))
hl.bind(mainMod .. " + SHIFT + P",     hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + U",             hl.dsp.focus({ urgent_or_last = true }))
hl.bind(mainMod .. " + CTRL + H",      hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + L",      hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + SHIFT + H", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.window.move({ workspace = "e+1" }))

-- Move focus vim-style (via custom script)
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("~/.config/hypr/bin/move_focus_window focus l"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/.config/hypr/bin/move_focus_window focus r"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("~/.config/hypr/bin/move_focus_window focus u"))
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd("~/.config/hypr/bin/move_focus_window focus d"))

-- Move focused monitor (arrow keys)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ monitor = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ monitor = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ monitor = "d" }))

-- Move windows vim-style (via custom script)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd("~/.config/hypr/bin/move_focus_window move l"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("~/.config/hypr/bin/move_focus_window move r"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("~/.config/hypr/bin/move_focus_window move u"))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd("~/.config/hypr/bin/move_focus_window move d"))

-- Move current workspace to other monitor (arrow keys)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.workspace.move({ monitor = "d" }))

-- Switch workspaces 1-10 and move window to workspace 1-10 (loop)
for i = 1, 10 do
    local key = i % 10  -- key 0 maps to workspace 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({
    name           = "ignore-maximize-requests",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name         = "maximized-window-border-color",
    match        = { fullscreen = true },
    border_color = "rgba(80aa9eee)",
})

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules
