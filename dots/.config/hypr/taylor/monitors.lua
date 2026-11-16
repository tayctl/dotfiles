----------------
--- MONITORS ---
----------------

local function laptopOnly()
    hl.monitor({ output = "eDP-1", mode = "1920x1200", position = "0x0", scale = 1 })
    hl.monitor({ output = "DP-8", disabled = true })
end

local function externalOnly()
    hl.monitor({ output = "DP-8", mode = "3840x2160", position = "auto", scale = 2 })
    hl.monitor({ output = "eDP-1", disabled = true })
end

hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1.5 })
hl.monitor({ output = "",      mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })

-- hl.monitor({ output = "DP-1",     mode = "preferred", position = "0x0", scale = 1.25 })
-- hl.monitor({ output = "HDMI-A-1", disabled = true })
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1, mirror = "DP-1" })

-- Hotkeys to switch between monitors
hl.bind("SUPER + SHIFT + Y", laptopOnly)
hl.bind("SUPER + SHIFT + U", externalOnly)
