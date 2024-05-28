return
{
    -- zbirenbaum copilot-cmp is very cool
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        vim.notify("COPILOT SETUP")
        require('copilot').setup({
            suggestion = {
                -- enabled = false,
                auto_trigger = true,
                keymap = {
                    accept = false,
                    accept_line = false,
                    accept_word = false,
                    next = false,
                    prev = false,
                    dismiss = false,
                    -- accept = "<M-j>",
                    -- accept_line = "<M-l>",
                    -- --  accept_word = "<M-k>",
                    -- next = "<M-'>",
                    -- prev = "<M-;>",
                    -- dismiss = "<M-h>",
                },
            },
            panel = {
                enabled = true,
                auto_refresh = false,
                keymap = {
                    jump_prev = "M-'",
                    jump_next = "M-;",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-CR>"
                },
                layout = {
                    position = "right", -- | top | left | right
                    ratio = 0.4
                },
            },
            server_opts_overrides = {
                settings = {
                    advanced = {
                        inlineSuggestCount = 3,
                        listCount = 5,
                    }
                }
            },
            filetypes = {
                markdown = true,
                yaml = true,
            }
        })
        -- lol
        -- do this so ai module can set keymaps
        require("copilot.command").disable()
    end
}
