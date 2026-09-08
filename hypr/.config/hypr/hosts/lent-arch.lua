-- See https://wiki.hypr.land/configuring/core/monitors/
-- hyprctl monitors all

hl.monitor({ output = "eDP-1",    mode = "2880x1800",    position = "0x0",        scale = 1.25 })
hl.monitor({ output = "DP-3",     mode = "3840x2160@30", position = "-384x-1728", scale = 1.25 })
-- hl.monitor({ output = "eDP-1", mode = "2880x1800",    position = "0x0",        scale = 1.5 })
-- hl.monitor({ output = "DP-3",  mode = "3840x2160@30", position = "-320x-1440", scale = 1.5 })
hl.monitor({ output = "DP-1",     mode = "3840x2160@30", position = "-320x-1440", scale = 1.5 })
hl.monitor({ output = "DP-5",     mode = "2560x1440",    position = "1920x0",     scale = 1.0 })
-- hl.monitor({ output = "HDMI-A-1", mode = "3840x2160", position = "1920x0",     scale = 1.0 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080",    position = "0x-1080",    scale = 1.0 })

local workspaces = {
    [1] = "eDP-1",
    [2] = "eDP-1",
    [3] = "DP-3",     -- DP-5 / DP-1
    [4] = "DP-3",     -- DP-5 / DP-1
    [5] = "eDP-1",    -- DP-7
    [6] = "eDP-1",
    [8] = "HDMI-A-1",
}
for ws, mon in pairs(workspaces) do
    hl.workspace_rule({ workspace = tostring(ws), monitor = mon })
end
