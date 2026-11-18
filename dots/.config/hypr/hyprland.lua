
---------------
--- SOURCES ---
---------------

-- Per-host files, linked into ~/.config/hypr-host by home-manager
-- (home/personal.nix or home/work.nix)
package.path = os.getenv("HOME") .. "/.config/hypr-host/?.lua;" .. package.path

require("host_monitors")
require("taylor.autostart")
require("host_autostart")
require("taylor.environment")
require("taylor.visuals")
require("taylor.input")
require("taylor.keybinds")
require("taylor.rules")
