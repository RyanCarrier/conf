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
                null_ls.builtins.formatting.beautysh,
                -- null_ls.builtins.formatting.prettierd
                -- null_ls.builtins.formatting.prettier.with({
                --     filetypes = {
                --         "javascript",
                --         "typescript",
                --         "css",
                --         "scss",
                --         "html",
                --         "json",
                --         "yaml",
                --         "markdown",
                --         "graphql",
                --         "md",
                --         "txt",
                --     },
                -- })
            },
            -- on_attach = function(client, bufnr)
            --     if client.supports_method("textDocument/formatting") then
            --         vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            --         vim.api.nvim_create_autocmd("BufWritePre", {
            --             group = augroup,
            --             buffer = bufnr,
            --             callback = function()
            --                 vim.lsp.buf.format({
            --                     bufnr = bufnr,
            --                     filter = function(client)
            --                         return client.name == "null-ls"
            --                     end
            --                 })
            --             end
            --         })
            --     end
            -- end,
        })
        null_ls.disable({ filetype = 'dart' });
        null_ls.disable({ filetype = 'lua' });
        -- null_ls.disable({ filetype = 'ts' });
        null_ls.disable({ filetype = 'typescript' });
    end,
}
