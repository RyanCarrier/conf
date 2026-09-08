-- Hyprland Lua config (0.55+). See https://wiki.hypr.land/configuring/core/
-- Editor completion: add /usr/share/hypr/stubs to your Lua LSP workspace library.

--------------------
---- HOST FILES ----
--------------------

-- Monitors / workspace layout live in hosts/<hostname>.lua
local host = io.popen("hostname"):read("*l")
local ok, err = pcall(require, "hosts/" .. host)
if not ok then
    hl.notification.create({ text = "No host config for " .. host .. ": " .. tostring(err), timeout = 8000, icon = "warning" })
end

-----------------
---- GENERAL ----
-----------------

hl.config({
    ecosystem = {
        no_update_news = true,
    },

    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "caps:escape",
        kb_rules     = "",
        follow_mouse = 1,
        accel_profile = "flat",
        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = false,
        },
    },

    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 1,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
    },

    misc = {
        disable_hyprland_logo  = true,
        animate_manual_resizes = true,
        background_color       = "rgb(000000)",
    },

    decoration = {
        rounding = 1,
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    gestures = {
        workspace_swipe_invert = false,
    },
})

hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 3, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 2, bezier = "default" })

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("swaync")
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wl-gammarelay")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("swayosd-server")
end)

---------------
---- BINDS ----
---------------

local mainMod = "SUPER"
local function bind(keys, dispatcher, opts)
    return hl.bind(mainMod .. " + " .. keys, dispatcher, opts)
end

-- Apps
bind("T",         hl.dsp.exec_cmd("ghostty"))
bind("E",         hl.dsp.exec_cmd("dolphin"))
bind("R",         hl.dsp.exec_cmd("wofi --show drun"))
bind("SPACE",     hl.dsp.exec_cmd("wofi --show drun"))
bind("M",         hl.dsp.exec_cmd("killall waybar; waybar"))
bind("CTRL + L",  hl.dsp.exec_cmd("hyprlock"))
bind("SHIFT + S", hl.dsp.exec_cmd("XDG_CURRENT_DESKTOP=sway flameshot gui"))
hl.bind("Print",  hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

-- Window management
bind("Q",         hl.dsp.window.close())
bind("SHIFT + Q", hl.dsp.exit())
bind("V",         hl.dsp.window.float({ action = "toggle" }))
bind("P",         hl.dsp.window.pseudo()) -- dwindle
bind("F",         hl.dsp.window.fullscreen())

-- Focus / move with arrows and hjkl
local dirs = {
    left = "left", right = "right", up = "up", down = "down",
    h = "left", l = "right", k = "up", j = "down",
}
for key, dir in pairs(dirs) do
    bind(key, hl.dsp.focus({ direction = dir }))
end
for _, key in ipairs({ "h", "l", "k", "j" }) do
    bind("SHIFT + " .. key, hl.dsp.window.move({ direction = dirs[key] }))
end

-- Resize with ALT + hjkl
bind("ALT + h", hl.dsp.window.resize({ x = -50, y = 0,   relative = true }))
bind("ALT + l", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }))
bind("ALT + k", hl.dsp.window.resize({ x = 0,   y = -50, relative = true }))
bind("ALT + j", hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }))

-- Workspaces: number row and keypad
local keypad = {
    "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin",
    "KP_Right", "KP_Home", "KP_Up", "KP_Prior", "KP_Insert",
}
for i = 1, 10 do
    for _, key in ipairs({ i % 10, keypad[i] }) do
        bind(tostring(key),              hl.dsp.focus({ workspace = i }))
        bind("SHIFT + " .. tostring(key), hl.dsp.window.move({ workspace = i }))
    end
end

-- Cycle workspaces
bind("mouse_down",  hl.dsp.focus({ workspace = "e+1" }))
bind("mouse_up",    hl.dsp.focus({ workspace = "e-1" }))
bind("TAB",         hl.dsp.focus({ workspace = "e+1" }))
bind("SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag / resize
bind("mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media / hardware keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd --output-volume raise"),       { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd --output-volume lower"),       { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd --output-volume mute-toggle"), { repeating = true })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness/raise.sh"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness/lower.sh"), { repeating = true })

-- Swallow Caps_Lock (kb_options remaps it to Escape)
hl.bind("Caps_Lock", hl.dsp.no_op(), { repeating = true })
