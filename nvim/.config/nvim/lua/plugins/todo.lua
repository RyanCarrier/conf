return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("todo-comments").setup({
            signs = true,

        })
        local todo = require("todo-comments.util")


        vim.keymap.set('n', '<leader>to', '<cmd>TodoTelescope<cr>',
            { desc = "[To]do list", silent = true, noremap = true })
    end,
}
