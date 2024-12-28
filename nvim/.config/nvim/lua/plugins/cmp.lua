return {
    -- Autocompletion
    'saghen/blink.cmp',
    -- specify version until we can build with nightly? idk just check the docs
    -- leave for now or manually update version
    version = '0.8.2',
    dependencies = {
        -- 'hrsh7th/cmp-nvim-lsp-signature-help',
        -- 'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        -- 'saadparwaiz1/cmp_luasnip',

        -- Adds LSP completion capabilities
        -- 'hrsh7th/cmp-nvim-lsp',

        -- Adds a number of user-friendly snippets
        -- 'rafamadriz/friendly-snippets',
    },
    -- build = "cargo build --release",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        completion = {
            menu = {
                draw = {
                    columns = {
                        { "label",     "label_description", gap = 1 },
                        { "kind_icon", "kind" }
                    },
                },
                auto_show = function(ctx) return ctx.mode ~= 'cmdline' end
                -- for disable on searching VVVV
                -- return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
            },
            documentation = {
                auto_show = true,
            },
        },
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- See the full "keymap" documentation for information on defining your own keymap.
        keymap = {
            preset = 'enter',
            ['<C-j>'] = { 'select_next', 'fallback' },
            ['<C-k>'] = { 'select_prev', 'fallback' },
        },
        -- signature = {
        --      -- something else already does this
        --     -- Enable the signature help
        --     enabled = true,
        -- },

        appearance = {
            -- Sets the fallback highlight groups to nvim-cmp's highlight groups
            -- Useful for when your theme doesn't support blink.cmp
            -- Will be removed in a future release
            -- use_nvim_cmp_as_default = true,
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    },
    opts_extend = { "sources.default" }
}
