-------------------
--- KEYBINDINGS ---
-------------------

local p = require("taylor.programs")
local mainMod = "SUPER"

local function bind(keys, dispatcher, opts)
    hl.bind(mainMod .. " + " .. keys, dispatcher, opts)
end

-- App launchers
bind("T",           hl.dsp.exec_cmd(p.terminal))
bind("Q",           hl.dsp.window.close())
bind("F",           hl.dsp.exec_cmd(p.fileManager))
bind("B",           hl.dsp.exec_cmd(p.browser))
bind("V",           hl.dsp.window.float({ action = "toggle" }))
bind("W",           hl.dsp.exec_cmd("pkill waybar || waybar &"))
bind("SPACE",       hl.dsp.exec_cmd(p.menu))
bind("P",           hl.dsp.window.pseudo()) -- dwindle
bind("I",           hl.dsp.exec_cmd("pkill -x iwgtk || iwgtk"))
bind("SHIFT + V",   hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
bind("SHIFT + E",   hl.dsp.exec_cmd("$HOME/.local/bin/power-menu"))
bind("SHIFT + T",   hl.dsp.exec_cmd("$HOME/.local/bin/theme"))

hl.bind("PRINT",         hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
bind("ESCAPE",           hl.dsp.exec_cmd("hyprlock"))

bind("SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- hyprpicker
bind("SHIFT + C", hl.dsp.exec_cmd("hyprpicker --autocopy"))

-- Move focus with mainMod + vim binds
bind("H", hl.dsp.focus({ direction = "left" }))
bind("J", hl.dsp.focus({ direction = "down" }))
bind("K", hl.dsp.focus({ direction = "up" }))
bind("L", hl.dsp.focus({ direction = "right" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    bind(tostring(key),             hl.dsp.focus({ workspace = i }))
    bind("SHIFT + " .. key,         hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind("mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind("mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
local el = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), el)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      el)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     el)
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   el)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"),                           el)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"),                           el)

-- Requires playerctl
local l = { locked = true }
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       l)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), l)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), l)
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   l)
