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

-- Workspaces 3/4 follow whichever external output is actually connected.
-- Connection is read straight from DRM (/sys/class/drm), so it works even
-- before Hyprland's IPC is up (cold boot) and re-runs on monitor hotplug.
local externals = { "DP-1", "DP-3", "DP-5", "HDMI-A-1" } -- priority order

local function pick_external()
    local present = {}
    local p = io.popen("grep -lx connected /sys/class/drm/*/status 2>/dev/null")
    if p then
        for path in p:lines() do
            local name = path:match("card%d+%-([^/]+)/status")
            if name then present[name] = true end
        end
        p:close()
    end
    for _, o in ipairs(externals) do
        if present[o] then return o, true end
    end
    return "DP-1", false -- fallback name when nothing external is connected
end

local function apply_workspaces(move)
    local external, connected = pick_external()
    local workspaces = {
        [1] = "eDP-1",
        [2] = "eDP-1",
        [3] = external,
        [4] = external,
        [5] = "eDP-1",    -- DP-7
        [6] = "eDP-1",
        [8] = "HDMI-A-1",
    }
    for ws, mon in pairs(workspaces) do
        hl.workspace_rule({ workspace = tostring(ws), monitor = mon })
    end
    -- On hotplug, pull already-open 3/4 onto the external that just appeared.
    if move and connected then
        hl.exec_cmd("hyprctl dispatch moveworkspacetomonitor 3 " .. external)
        hl.exec_cmd("hyprctl dispatch moveworkspacetomonitor 4 " .. external)
    end
end

apply_workspaces(false)
hl.on("monitor.added",   function() apply_workspaces(true) end)
hl.on("monitor.removed", function() apply_workspaces(true) end)
