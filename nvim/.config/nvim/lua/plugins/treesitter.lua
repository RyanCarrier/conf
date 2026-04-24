return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
            local tspre = "TS"
            local tsselect = tspre .. " Select: "
            local tsmove = tspre .. " Move: "

            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    disable = { "python" },
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local select_maps = {
                { "aa", "@parameter.outer", tsselect .. "Inside parameter (yes ',')" },
                { "ia", "@parameter.inner", tsselect .. "Inside parameter (no ',')" },
                { "af", "@function.outer",  tsselect .. "Around function" },
                { "if", "@function.inner",  tsselect .. "Inside function" },
                { "ac", "@class.outer",     tsselect .. "Around class" },
                { "ic", "@class.inner",     tsselect .. "Inside class" },
                { "al", "@loop.outer",      tsselect .. "Around loop" },
                { "il", "@loop.inner",      tsselect .. "Inside loop" },
            }
            for _, m in ipairs(select_maps) do
                vim.keymap.set({ "x", "o" }, m[1], function()
                    select.select_textobject(m[2], "textobjects")
                end, { desc = m[3] })
            end

            local move = require("nvim-treesitter-textobjects.move")
            vim.keymap.set({ "n", "x", "o" }, "]f", function()
                move.goto_next_start("@function.outer", "textobjects")
            end, { desc = tsmove .. "Next Function Start" })
            vim.keymap.set({ "n", "x", "o" }, "]c", function()
                move.goto_next_start("@class.outer", "textobjects")
            end, { desc = tsmove .. "Next Class Start" })
            vim.keymap.set({ "n", "x", "o" }, "]F", function()
                move.goto_next_end("@function.outer", "textobjects")
            end, { desc = tsmove .. "Next Function End" })
            vim.keymap.set({ "n", "x", "o" }, "]C", function()
                move.goto_next_end("@class.outer", "textobjects")
            end, { desc = tsmove .. "Next Class End" })
            vim.keymap.set({ "n", "x", "o" }, "[f", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end, { desc = tsmove .. "Previous Function Start" })
            vim.keymap.set({ "n", "x", "o" }, "[c", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end, { desc = tsmove .. "Previous Class Start" })
            vim.keymap.set({ "n", "x", "o" }, "[F", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end, { desc = tsmove .. "Previous Function End" })
            vim.keymap.set({ "n", "x", "o" }, "[C", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end, { desc = tsmove .. "Previous Class End" })

            local swap = require("nvim-treesitter-textobjects.swap")
            vim.keymap.set("n", "<leader>an", function()
                swap.swap_next("@parameter.inner")
            end, { desc = "Swap parameter with next" })
            vim.keymap.set("n", "<leader>ap", function()
                swap.swap_previous("@parameter.inner")
            end, { desc = "Swap parameter with previous" })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        config = function()
            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })
        end,
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    if vim.bo.filetype == "python" then
                        pcall(vim.treesitter.start)
                        return
                    end
                    pcall(vim.treesitter.start)
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
            vim.filetype.add({ pattern = { [".*/hyprland%.conf"] = "hyprlang" } })

            -- incremental node selection (replaces old treesitter incremental_selection)
            vim.keymap.set("n", "<C-space>", "van", { desc = "TS Select: Init node selection", remap = true })
            vim.keymap.set("x", "<C-space>", "an", { desc = "TS Select: Increment node", remap = true })
            vim.keymap.set("x", "<M-space>", "in", { desc = "TS Select: Decrement node", remap = true })

            local mts = require("modules.treesitter")
            local tsmove = "TS Move: "
            vim.keymap.set("n", "[[", function()
                mts:move_parent("list_literal", true)
            end, { desc = tsmove .. "Previous List Start" })
            vim.keymap.set("n", "]]", function()
                mts:move_parent("list_literal", false)
            end, { desc = tsmove .. "Next List End" })
        end,
    },
    {
        "lewis6991/ts-install.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("ts-install").setup({
                ensure_install = {
                    "c", "cpp", "go", "lua", "python", "rust", "tsx",
                    "typescript", "vimdoc", "vim", "bash", "dart",
                    "hyprlang", "zig", "toml", "yaml", "gomod", "json", "jsonc",
                },
                auto_install = true,
            })
        end,
    },
}
