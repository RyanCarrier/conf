return {
    'sidlatau/neotest-dart',
    'nvim-neotest/neotest-go',
    'rouge8/neotest-rust',
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",

            'sidlatau/neotest-dart',
            'nvim-neotest/neotest-go',
            'rouge8/neotest-rust',
        },
        config = function()
            require('neotest').setup({
                adapters = {
                    require('neotest-rust'),
                    require('neotest-go'),
                    require('neotest-dart') {
                        command = 'flutter',
                        use_lsp = true,
                    },
                },
                summary = {
                    -- default values but lets me see the default keymaps/change then
                    animated = true,
                    enabled = true,
                    expand_errors = true,
                    follow = true,
                    mappings = {
                        attach = "a",
                        clear_marked = "M",
                        clear_target = "T",
                        debug = "d",
                        debug_marked = "D",
                        expand = { "<CR>", "<2-LeftMouse>" },
                        expand_all = "e",
                        help = "?",
                        jumpto = "i",
                        mark = "m",
                        next_failed = "J",
                        output = "o",
                        prev_failed = "K",
                        run = "r",
                        run_marked = "R",
                        short = "O",
                        stop = "u",
                        target = "t",
                        watch = "w"
                    },
                    open = "botright vsplit | vertical resize 50"
                },


            })
        end,

    },
}
