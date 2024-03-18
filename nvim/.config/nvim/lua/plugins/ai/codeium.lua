return {
    {
        -- for virtual text
        'Exafunction/codeium.vim',
        event = 'BufEnter',
        config = function()
            vim.g.codeium_disable_bindings = 1
            -- vim.g.codeium_virtual_text = true
            vim.g.codeium_enabled = false
            -- require('codeium').setup()
        end
    },

    -- {
    --     --for nvim cmp
    --     "Exafunction/codeium.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "hrsh7th/nvim-cmp",
    --     },
    --     config = function()
    --         require("codeium").setup({
    --         })
    --     end
    -- },
}
