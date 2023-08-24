return {
    'folke/which-key.nvim',
    config = function()
        local wk = require("which-key")
        wk.setup()
        wk.register({
            w = {
                w = {
                    name = "Workspace",
                }
            },
        }, {
            prefix = "<leader>",
            mode = "n",
        })
    end
}
