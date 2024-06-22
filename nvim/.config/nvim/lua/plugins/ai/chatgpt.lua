return {
    "jackMort/ChatGPT.nvim",
    -- event = "VeryLazy",
    lazy = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },
    config = function()
        local apifile = "/home/rcarrier/.chatgpt.api.key"
        local f = io.open(apifile, "r")
        local file_exists = f ~= nil and io.close(f)
        if not file_exists then
            vim.notify("No ChatGPT API key found at $HOME/.chatgpt.api.key")
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
        vim.keymap.set("n", "<leader>ai", chatgpt.openChat, { noremap = true, silent = true, desc = "[AI] [C]hat" })
    end,
}
