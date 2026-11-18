------------------------
--- AUTOSTART (WORK) ---
------------------------

hl.on("hyprland.start", function()
    -- turns eDP-1 off while docked, see ~/.config/kanshi/config (home/work.nix)
    hl.exec_cmd("kanshi")
    hl.exec_cmd("teams-for-linux", { workspace = "3 silent" })
end)
