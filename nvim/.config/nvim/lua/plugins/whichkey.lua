return {
    'folke/which-key.nvim',
    config = function()
        local wk = require("which-key")
        wk.setup()
        wk.register({
            w = {
                o = {
                    name = "[Wo]rkspace",
                }
            },
        }, {
            prefix = "<leader>",
            mode = "n",
        })
    end
}
