-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    local dapm = require('modules.dap')
    require('mason-nvim-dap').setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},
      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    })
    local nmap = function(keys, func, desc)
      if desc then desc = 'DAP: ' .. desc end
      vim.keymap.set('n', keys, func, { desc = desc })
    end
    nmap("<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, "Debug Nearest")
    nmap('<F5>', dap.continue, "Continue")
    nmap('<F1>', dap.step_into, "Step into")
    nmap('<F2>', dap.step_over, "Step over")
    nmap('<F3>', dap.step_out, "Step out")
    nmap('<leader>b', dap.toggle_breakpoint, "Toggle [b]reakpoint")
    nmap('<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, "Conditional [B]reakpoint")

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          -- run_last = '▶▶',
          terminate = '⏹',
          disconnect = "⏏",
        },
      },
      layouts = dapm.dapui_layouts,
    })

    local function set_dap_ex_bp(filter)
      return function()
        if not filter then
          dap.set_exception_breakpoints()
        else
          dap.set_exception_breakpoints({ filter })
          vim.notify('Exception breakpoints set to ' .. filter)
        end
      end
    end

    -- toggle to see last session result. Without this ,you can't see session output in case of unhandled exception.
    nmap("<F6>", dapm.toggle_fn(dapm.REPL_TROUBLE), "Trouggle")
    nmap("<F7>", dapm.toggle_fn(dapm.FULL), "FAT")
    nmap("<F8>", dapm.toggle_fn(dapm.REPL_LEFT_LOL), "BIG REPL LEFT")
    -- nmap("<leader>de", dap.set_exception_breakpoints(""), "[D]ebug [E]xception catch all")
    nmap("<leader>dd", set_dap_ex_bp('default'), "[D]ebug [D]efault exception")
    nmap("<leader>dr", set_dap_ex_bp('raised'), "[D]ebug [R]aised exceptions")
    nmap("<leader>dn", function() dap.set_exception_breakpoints({}) end, "[D]ebug [N]o exception catching")
    nmap("<leader>du", set_dap_ex_bp('uncaught'),
      "[D]ebug [U]ncaught (only) exception catching")
    nmap("<leader>dU", set_dap_ex_bp('Unhandled'),
      "[D]ebug [U]handled (only) exception catching")

    dap.listeners.after.event_initialized['dapui_config'] = dapm.toggle_fn(dapm.REPL_TROUBLE)
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    -- wot
    require('dap-go').setup()
  end,
}
