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

                }
            })
        end,

    },
}
