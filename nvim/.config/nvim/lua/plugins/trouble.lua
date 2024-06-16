return {
    'folke/trouble.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    lazy = false,
    opts = {
        open_no_results = true,
        modes = {
            diagnostics_buffer = {
                mode = "diagnostics",
                filter = { buf = 0 },
                groups = {
                    "filename",
                    format = "{file_icon} {basename:Title} {count}",
                },
            },
            diagnostics_workspace = {
                mode = "diagnostics",
                groups = {
                    "filename",
                    format = "{file_icon} {basename:Title} {count}",
                },
            },
        },
    },
}
