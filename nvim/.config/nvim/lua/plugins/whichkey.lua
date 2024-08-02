return {
    'folke/which-key.nvim',
    config = function()
        local wk = require("which-key")
        wk.setup()
        wk.add({
            {
                "<leader>wO", group = "[WO]rkspace",
            }
        })
        wk.add({
            {
                "<leader>?",
                function() wk.show({ global = false }) end,
                desc = "Buffer Local Keymaps (WhichKey)"
            }
        })
    end
}
