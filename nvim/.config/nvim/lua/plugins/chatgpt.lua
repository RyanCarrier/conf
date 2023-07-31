return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
        require("chatgpt").setup({
            api_key_cmd = "cat /home/rcarrier/.chatgpt.api.key",
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
