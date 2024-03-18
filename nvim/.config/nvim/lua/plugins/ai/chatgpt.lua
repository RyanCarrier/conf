return {
    "jackMort/ChatGPT.nvim",
    -- event = "VeryLazy",
    lazy = true,
    config = function()
        local apifile = "/home/rcarrier/.chatgpt.api.key"
        local f = io.open(apifile, "r")
        local file_exists = f ~= nil and io.close(f)
        if not file_exists then
            print("No ChatGPT API key found")
            return
        end
        local chatgpt = require("chatgpt")
        chatgpt.setup({
            api_key_cmd = "cat " .. apifile,
            -- chat = {
            --     keymaps = {
            --         submit = { "<C-m>", "<C-Enter>", "<C-t>" },
            --     }
            -- }
            popup_input = {
                submit = "<c-m>",
            },
            chat = {
                keymaps = {
                    close = "<Esc>",
                }
            },
            openai_params = {
                max_tokens = 1000,
            }
        })
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    }
}
