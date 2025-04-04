return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        "gbprod/none-ls-shellcheck.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                -- none_ls.builtins.diagnostics.eslint, not present in none ls?
                -- null_ls.builtins.completion.spell, -- spell check
                -- null_ls.builtins.code_actions.shellcheck,
                -- require("none-ls-shellcheck.diagnostics"),
                -- require("none-ls-shellcheck.code_actions"),
                -- null_ls.builtins.formatting.beautysh,
                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.formatting.rubyfmt,
                -- null_ls.builtins.formatting.prettierd,
                -- none_ls.builtins.formatting.prettier.with({
                null_ls.builtins.formatting.prettierd.with({
                    filetypes = {
                        -- "javascript",
                        -- "typescript",
                        "css",
                        "scss",
                        "html",
                        "json",
                        "jsonc",
                        "markdown",
                        "graphql",
                        "md",
                        "txt",
                        "yml",
                        "yaml",
                        "hcl",
                    },
                    -- why won't you work
                    -- extra_filetypes = { "toml" },
                }),
                null_ls.builtins.diagnostics.actionlint, -- github actions
                null_ls.builtins.diagnostics.commitlint, -- git commit
                null_ls.builtins.diagnostics.hadolint,   -- dockerfile
            },
            on_attach = require("after.lsp.on_attach").on_attach,
        })
        null_ls.disable({ filetype = 'dart' });
        null_ls.disable({ filetype = 'dartls' });
        null_ls.disable({ filetype = 'lua' });
        -- null_ls.disable({ filetype = 'ts' });
        null_ls.disable({ filetype = 'typescript' });
    end,
}
