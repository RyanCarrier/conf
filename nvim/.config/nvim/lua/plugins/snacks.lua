-- lazy.nvim
return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        image = { enabled = true },
        bigfile = { enabled = true },
        indent = {
            enabled = true,
            animate = {
                duration = {
                    step = 6,
                    total = 150,
                },
            },

        },
    }
}
