return {
    'folke/trouble.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    opts = {},
    config = function()
        local t = require('trouble')
        local trouble_next = function()
            t.next({ skip_groups = true, jump = true });
        end
        -- Lua
        local nmap = function(input, cmd, desc)
            vim.keymap.set("n", input,
                "<cmd>Trouble diagnostics " .. cmd .. "<cr>"
                , { desc = "[Trouble] " .. desc })
        end
        nmap("<leader>xx", "toggle", "Toggle")
        nmap("<leader>xw", "open", "Workspace diagnostics")
        nmap("<leader>xd", "open filter.buf=0", "Document diagnostics")
        -- nmap("gR", "lsp_references", "LSP references")

        vim.keymap.set('n', '<C-t>', trouble_next, { silent = true, noremap = true, desc = "Trouble next" })
        vim.keymap.set('n', '<leader>xn', trouble_next, { silent = true, noremap = true, desc = "Trouble [N]ext" })
    end
}
