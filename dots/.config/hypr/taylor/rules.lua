------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

hl.window_rule({
    name  = "iwgtk-floating",
    match = { class = "^(org\\.twosheds\\.iwgtk)$" },

    float = true,
    size  = "400 600",
    move  = "1545 40",
})

hl.window_rule({
    name  = "blueman-floating",
    match = { class = "^(blueman-manager)$" },

    float = true,
    size  = "400 600",
    move  = "1545 40",
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

local centered = {
    { name = "center-open-file",  match = { title = "^(Open File)$" } },
    { name = "center-save-as",    match = { title = "^(Save As)$" } },
    { name = "center-open",       match = { title = "^(Open)$" } },
    { name = "center-portal",     match = { class = "^(xdg-desktop-portal-gtk)$" } },
    { name = "center-fdo-portal", match = { class = "^(org\\.freedesktop\\.impl\\.portal)$" } },
}

for _, rule in ipairs(centered) do
    rule.center = true
    hl.window_rule(rule)
end
