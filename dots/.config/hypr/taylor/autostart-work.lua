------------------------
--- AUTOSTART (WORK) ---
------------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("teams-for-linux", { workspace = "3 silent" })
end)
