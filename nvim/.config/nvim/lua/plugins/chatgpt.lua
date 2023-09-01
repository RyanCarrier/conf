return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
        local chatgpt = require("chatgpt")
        chatgpt.setup({
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
        local wk = require("which-key")
        wk.register({
            a = {
                name = "ChatGPT",
                i = {
                    chatgpt.edit_with_instructions,
                    "Edit with instructions",
                },
                f = {
                    "<cmd>ChatGPTRun fix_bugs<CR>",
                    "[F]ix bugs",
                },
                d = {
                    "<cmd>ChatGPTRun docstring<CR>",
                    "[D]ocstring",
                },
            },
        }, {
            prefix = "<leader>",
            mode = "v",
        })

        wk.register({
            a = {
                name = "ChatGPT",
                i = {
                    chatgpt.openChat,
                    "Chat with [AI]",
                },
                p = {
                    function()
                        chatgpt.selectAwesomePrompt()
                    end,
                    "Chat with [A]I [P]rompt",
                },
            },
        }, {
            prefix = "<leader>",
            mode = "n",
        })
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    }
}
