local dap = require('dap')
local dapm = require('modules.dap')

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
