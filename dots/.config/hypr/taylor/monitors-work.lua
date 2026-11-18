-----------------------
--- MONITORS (WORK) ---
-----------------------

-- HP ZBook Studio 16 G11, mostly docked to a 4K BenQ RD320U. kanshi
-- (host_autostart) disables eDP-1 while an external monitor is connected;
-- these rules are the fallback.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.5 })
hl.monitor({ output = "",      mode = "preferred", position = "auto", scale = 1.5 })
