return {
    'folke/which-key.nvim',
    config = function()
        local wk = require("which-key")
        wk.setup()
        wk.register({
            w = {
                O = {
                    name = "[WO]rkspace",
                }
            },
        }, {
            prefix = "<leader>",
            mode = "n",
        })
    end
}
