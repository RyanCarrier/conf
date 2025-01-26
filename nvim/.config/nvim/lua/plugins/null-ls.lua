return {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.diagnostics.eslint,
                null_ls.builtins.completion.spell,
                null_ls.builtins.code_actions.shellcheck,
                -- require("none-ls-shellcheck.diagnostics"),
                -- require("none-ls-shellcheck.code_actions"),
                -- null_ls.builtins.formatting.beautysh,
                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.formatting.rubyfmt,
                -- null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.prettier.with({
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
                null_ls.builtins.formatting.taplo,
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
