return {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
        -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        -- parser_config.hypr = {
        --     install_info = {
        --         url = "https://github.com/luckasRanarison/tree-sitter-hypr",
        --         files = { "src/parser.c" },
        --         branch = "master",
        --     },
        --     filetype = "hypr",
        -- }
        local nts = require('nvim-treesitter.configs')
        local tspre = 'TS'
        local tsselect = tspre .. ' Select: '
        local tsmove = tspre .. ' Move: '
        nts.setup({
            modules = {},
            sync_install = true,
            ignore_install = {},
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'bash',
                'dart',
                'zig', 'toml', 'yaml', 'gomod', 'json' },

            -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself! )
            auto_install = true,

            highlight = { enable = true },
            indent = { enable = true, disable = { 'python', 'dart', 'dartls' } },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                    scope_incremental = '<c-s>',
                    node_decremental = '<M-space>',
                },
            },
            textobjects = {
                select = {
                    --BROKEN FOR DART QQ
                    -- or atleast it's just slow af
                    enable = true,
                    -- disable = { 'python', 'dart', 'dartls' },
                    disable = { 'python' },
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['ag'] = { query = '@parameter.outer', desc = tsselect .. 'idk around parameter?' },
                        ['ia'] = { query = '@parameter.inner', desc = tsselect .. 'idk inside parameter?' },
                        ['af'] = { query = '@function.outer', desc = tsselect .. 'Around function' },
                        ['if'] = { query = '@function.inner', desc = tsselect .. 'Inside function' },
                        ['ac'] = { query = '@class.outer', desc = tsselect .. 'Around class' },
                        ['ic'] = { query = '@class.inner', desc = tsselect .. 'Inside class' },
                        ['al'] = { query = '@loop.outer', desc = tsselect .. 'Around loop' },
                        ['il'] = { query = '@loop.inner', desc = tsselect .. 'Inside loop' },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']f'] = { query = '@function.outer', desc = tsmove .. 'Next Function Start' },
                        [']c'] = { query = '@class.outer', desc = tsmove .. 'Next Class Start' },
                    },
                    goto_next_end = {
                        [']F'] = { query = '@function.outer', desc = tsmove .. 'Next Function End' },
                        [']C'] = { query = '@class.outer', desc = tsmove .. 'Next Class End' },
                    },
                    goto_previous_start = {
                        ['[f'] = { query = '@function.outer', desc = tsmove .. 'Previous Function Start' },
                        ['[c'] = { query = '@class.outer', desc = tsmove .. 'Previous Class Start' },
                    },
                    goto_previous_end = {
                        ['[F'] = { query = '@function.outer', desc = tsmove .. 'Previous Function End' },
                        ['[C'] = { query = '@class.outer', desc = tsmove .. 'Previous Class End' },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        -- lol
                        ['<leader>a'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>A'] = '@parameter.inner',
                    },
                },
            },
        })
    end,
}
