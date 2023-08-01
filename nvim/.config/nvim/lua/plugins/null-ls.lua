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
            },
        })
        null_ls.disable({ filetype = 'dart' });
    end,
}
