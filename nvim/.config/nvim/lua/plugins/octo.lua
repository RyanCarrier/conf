-- GitHub PR / issue review inside nvim. Uses the `gh` CLI for auth.
-- Keymaps live in lua/rcarrier/keymaps.lua under the <leader>go group.
return {
    "pwntester/octo.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    opts = {
        picker = "telescope",
    },
}
