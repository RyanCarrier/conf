return {
    {
        'RyanCarrier/pubspec-assist.nvim',
        -- dir = '~/Projects/pubspec-assist.nvim',
        -- name = 'pubspec-assist.nvim',
        -- dev = true,
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('pubspec-assist').setup();
        end
    },
    {
        'nvim-flutter/flutter-tools.nvim',
        -- 'RyanCarrier/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
            'mfussenegger/nvim-dap',
        },
        config = function()
            require("telescope").load_extension("flutter")
            require("flutter-tools").setup({
                dev_log = {
                    enabled = false,
                },
                widget_guides = {
                    enabled = false,
                },
                closing_tags = {
                    enabled = true,
                },
                lsp = {
                    color = {
                        enabled = true,
                        virtual_text = true,
                    },
                    settings = {
                        showTodos = false,
                        analysisExcludedFolders = {
                            vim.fn.expand("/opt/flutter/packages"),
                            vim.fn.expand("/opt/flutter/bin/cache"),
                            vim.fn.expand("$HOME/.pub-cache"),
                        },
                        updateImportsOnRename = true,
                    },
                    -- capabilities = function(config)
                    --     config.enableSdkFormatter = false
                    -- end,
                    -- lol?
                    on_attach = require("after.lsp.on_attach").on_attach,
                },
                decorations = {
                    statusline = {
                        app_version = true,
                        device = true,
                    },
                },
                debugger = {
                    -- integrate with nvim dap + install dart code debugger
                    enabled = true,
                    run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
                    -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
                    -- see |:help dap.set_exception_breakpoints()| for more info
                    -- exception_breakpoints = { "Unhandled" },
                    exception_breakpoints = {},
                    register_configurations = function(_)
                        require("dap").configurations.dart = {}
                        require("dap.ext.vscode").load_launchjs()
                    end
                },
                dev_tools = {
                    autostart = true,
                    auto_open_browser = false,
                },
            })
            require("dap").adapters.dart = {
                type = "executable",
                command = "flutter",
                args = { "debug-adapter" },
            }
            vim.keymap.set("n", "<leader>fl", function()
                require("telescope").extensions.flutter.commands()
            end, { desc = "[Fl]utter" })
            vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRestart<cr>",
                { desc = "[F]lutter [R]estart (not reload, just save a file bro)" })
            vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<cr>",
                { desc = "[F]lutter [Q]uit" })
            -- flutter outline
            vim.keymap.set("n", "<leader>fo", "<CMD>FlutterOutlineToggle<cr>"
            , { desc = "[F]lutter [O]utline" })
        end
    },
}
