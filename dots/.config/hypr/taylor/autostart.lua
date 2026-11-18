-----------------
--- AUTOSTART ---
-----------------

local p = require("taylor.programs")

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("waybar")
    hl.exec_cmd("udiskie --tray")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-manager")

    --------------------
    --- STARTUP APPS ---
    --------------------

    hl.exec_cmd(p.terminal,       { workspace = "1 silent" })
    hl.exec_cmd(p.browser,        { workspace = "2 silent" })
    hl.exec_cmd(p.fileManager,    { workspace = "4 silent" })
    -- hl.exec_cmd("bitwarden-desktop", { workspace = "8 silent" })
    -- hl.exec_cmd("pika-backup",       { workspace = "9 silent" })
    -- hl.exec_cmd("thunderbird",       { workspace = "10 silent" })
end)
