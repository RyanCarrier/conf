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
        local t = require('trouble')
        local trouble_next = function()
            t.next({ skip_groups = true, jump = true });
        end



        -- Lua -- TROUBLE
        -- Lua
        local nmap = function(input, trouble_type, desc)
            vim.keymap.set("n", input, function() t.open(trouble_type) end, { desc = "[Trouble] " .. desc })
        end
        nmap("<leader>xx", "", "Toggle")
        nmap("<leader>xw", "workspace_diagnostics", "Workspace diagnostics")
        nmap("<leader>xd", "document_diagnostics", "Document diagnostics")
        nmap("<leader>xq", "quickfix", "Quickfix")
        nmap("<leader>xl", "loclist", "Loclist")
        nmap("gR", "lsp_references", "LSP references")

        vim.keymap.set('n', '<C-t>', trouble_next, { silent = true, noremap = true, desc = "Trouble next" })
        vim.keymap.set('n', '<leader>tn', trouble_next, { silent = true, noremap = true, desc = "[T]rouble [N]ext" })
    end
}
