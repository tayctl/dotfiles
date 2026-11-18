----------------------------
--- AUTOSTART (PERSONAL) ---
----------------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start filen-automount.service")
    hl.exec_cmd("pika-backup-monitor")
    hl.exec_cmd("signal-desktop", { workspace = "3 silent" })
end)
