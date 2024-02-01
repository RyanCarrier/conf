if vim.g.neovide then
    -- scaling
    vim.g.neovide_scale_factor = 1
    local change_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
    end
    vim.keymap.set("n", "<C-=>", function()
        change_scale_factor(0.05)
    end)
    vim.keymap.set("n", "<C-->", function()
        change_scale_factor(-0.05)
    end)
    -- pasting
    vim.keymap.set('i', '<C-S-v>', '<C-r>+', { noremap = true })

    -- gamer moments
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_scroll_animation_length = 0.1
    -- vim.g.neovide_profiler = true
    -- cursor
    vim.g.neovide_cursor_animation_length = 0.02
    vim.g.neovide_cursor_trail_size = 0.5
    vim.g.neovide_cursor_animate_command_line = true

    vim.o.guifont = "DejaVuSansM Nerd Font Mono:h10"
end
