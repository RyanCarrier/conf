return {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
        'onsails/lspkind-nvim',
        --     'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        -- 'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-path',
        --     'hrsh7th/cmp-buffer',
        -- 'hrsh7th/vim-vsnip',

        -- Snippet Engine & its associated nvim-cmp source
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',

        -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp',

        -- Adds a number of user-friendly snippets
        -- 'rafamadriz/friendly-snippets',
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local lspkind = require('lspkind')
        cmp.setup({

            formatting = {
                -- fields = {},
                -- expandable_indicator = false,
                format = function(entry, vim_item)
                    vim_item = lspkind.cmp_format({
                        mode = 'symbol_text',
                        -- maxwidth = 50,
                        -- ellipsis_char = '...',
                    })(entry, vim_item)
                    
                    -- vim_item.kind = lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        buffer = "[Buffer]",
                        path = "[Path]",
                        gh_issues = "[GitHub]",
                        copilot = "[GitHub]",
                    })[entry.source.name]
                    if vim_item.menu == nil then
                        vim_item.menu = "[Unknown](" .. entry.source.name .. ")"
                    end
                    -- vim_item.dup = ({ luasnip = 0, })[entry.source.name] or nil
                    return vim_item
                end,
            },

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sorting = {
                priority_weight = 2,
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,

                    -- copied from cmp-under, but I don't think I need the plugin for this.
                    -- I might add some more of my own.
                    -- function(entry1, entry2)
                    --     local _, entry1_under = entry1.completion_item.label:find "^_+"
                    --     local _, entry2_under = entry2.completion_item.label:find "^_+"
                    --     entry1_under = entry1_under or 0
                    --     entry2_under = entry2_under or 0
                    --     if entry1_under > entry2_under then
                    --         return false
                    --     elseif entry1_under < entry2_under then
                    --         return true
                    --     end
                    -- end,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                }
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
                border = 'rounded',
                scrollbar = true,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete({}),
                ['<CR>'] = cmp.mapping.confirm({
                    -- behavior = cmp.ConfirmBehavior.Replace,
                    -- select = true,
                }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable() then
                        luasnip.jump(1)
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp', dup = 0 },
                { name = 'luasnip',  dup = 0 },
                { name = 'copilot' },
            }, {
                { name = "path" },
                { name = "buffer", keyword_length = 5 },
            }, {
                { name = "gh_issues" },
            }),
        })
    end
}
