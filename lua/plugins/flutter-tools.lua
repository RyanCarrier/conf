return {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
        'mfussenegger/nvim-dap',

    },
    config = function()
        require("telescope").load_extension("flutter")
        require("flutter-tools").setup({
            dev_log = { enabled = false },
            widget_guides = { enabled = true },
            lsp = {
                color = { enabled = true },
            },
            debugger = {
                -- integrate with nvim dap + install dart code debugger
                enabled = true,
                run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
                -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
                -- see |:help dap.set_exception_breakpoints()| for more info
                exception_breakpoints = {},
                register_configurations = function(_)
                    require("dap").configurations.dart = {}
                    require("dap.ext.vscode").load_launchjs()
                end
            },
            lsp = {
                settings = {
                    -- analysisExcludedFolders = { ".dart_tool/**", "**/.*" }
                }
            }
        })
    end
}
