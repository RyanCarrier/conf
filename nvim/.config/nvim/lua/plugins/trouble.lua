return {
    'folke/trouble.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function()
        require('trouble').setup({
            position = "bottom",
            height = 10,
            width = 50,
            icons = true,
            mode = "document_diagnostics",
            fold_open = "",
            fold_closed = "",
            action_keys = {
                close = "q",
                cancel = "<esc>",
                refresh = "r",
                jump = { "<cr>", "<tab>" },
                open_split = { "<c-x>" },
                open_vsplit = { "<c-v>" },
                open_tab = { "<c-t>" },
                jump_close = { "o" },
                toggle_mode = "m",
                toggle_preview = "P",
                preview = "p",
                close_folds = { "zM", "zm" },
                open_folds = { "zR", "zr" },
                toggle_fold = { "zA", "za" },
                previous = "k",
                next = "j"
            },
            indent_lines = true,
            auto_open = false,
            auto_close = false,
            auto_preview = false,
            auto_fold = false,
            signs = {
                error = "",
                warning = "",
                hint = "",
                information = "",
                other = "﫠"
            },
            -- use_lsp_diagnostic_signs = false
        })
        local trouble_next = function()
            require("trouble").next({ skip_groups = true, jump = true });
        end



        -- Lua -- TROUBLE
        vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
        vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
            { silent = true, noremap = true })
        vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
            { silent = true, noremap = true })
        vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
        vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
        vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
        vim.keymap.set('n', '<C-t>', trouble_next, { silent = true, noremap = true, desc = "Trouble next" })
        vim.keymap.set('n', '<leader>tn', trouble_next, { silent = true, noremap = true, desc = "[T]rouble [N]ext" })
    end
}
