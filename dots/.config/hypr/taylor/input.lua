-------------
--- INPUT ---
-------------

hl.config({
    input = {
        kb_layout  = "dk",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:swapescape",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity    = -1.0,
        force_no_accel = false,

        touchpad = {
            natural_scroll = true,
        },
    },
})

---------------
--- DEVICES ---
---------------

hl.device({ name = "kinesis-corporation-adv360-pro-keyboard", kb_options = "" })
hl.device({ name = "moergo-glove80-left-keyboard",            kb_options = "" })

hl.device({ name = "logitech-usb-receiver-mouse",     sensitivity = -1.0 })
hl.device({ name = "razer-razer-abyssus-essential-1", sensitivity = -1.0 })
hl.device({ name = "elan0678:00-04f3:3195-touchpad",  sensitivity = 0.0 })
hl.device({ name = "syna3127:00-06cb:cebb-touchpad",  sensitivity = 0.5 })

for _, suffix in ipairs({ "", "-system-control", "-consumer-control", "-keyboard" }) do
    hl.device({ name = "kbdfans-maja_soldered" .. suffix, kb_options = "caps:none" })
end
