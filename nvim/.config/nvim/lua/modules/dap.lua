-- this is the dumbest shit so i think it really suits me
local M = {}
local dapui = require('dapui')
local dap = require('dap')
local t = require('trouble')

---@alias layout_option integer

---@type layout_option
M.FULL = 1
---@type layout_option
M.REPL_CONSOLE = 2
---@type layout_option
M.REPL_TROUBLE = 3
---@type layout_option
M.REPL = 4
---@type layout_option
M.REPL_LEFT_LOL = 5


-- trougg = trouble+toggle+debug
---@param open boolean
local function trouggle(open)
	-- fucking v3 trouble uses async for everything so you can't do any sequential shit
	if not open then
		dapui.close({ layout = M.REPL })
		-- dap.repl.close()
		t.close()
		return
	end
	t.close()
	-- start creation of the ui buttons????
	dapui.open({ layout = M.REPL })
	-- dapui.close({ layout = M.REPL })
	-- dap.repl.close()
	-- i don't even know if this works anymore, but it  might so we will keep it???/
	-- VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
	--have a secret small layout for a mini repl (size 1), to enable the controlls
	-- controlls will then be passed to any other repl window too
	-- there was some issue doing this before trouble, I don't remember what,
	-- no harm but it works here... just weird
	-- dapui.open({ layout = M.REPL })
	-- dapui.close({ layout = M.REPL })
	-- dapui.open({ layout = M.REPL_TROUBLE })
	-- dap.repl.open({ height = 20 })
	-- i want to die
	vim.cmd("wincmd j")
	local winwidth = vim.fn.winwidth(0)
	t.open({
		mode = "diagnostics_workspace",
		win = {
			type = "split",
			relative = "win",
			position = "right",
			size = {
				width = winwidth * 0.5,
			},
		},
	})
	-- select back to repl to active buttons?
	-- it didn't work i think the app needs to be fully running?
	-- vim.cmd("wincmd h")
	vim.cmd("wincmd k")
end

---@class layout
---@field title string
---@field open boolean
---@field fn function<boolean>?

---@type layout[]
---@private
M.layouts = {
	{
		title = "FULL",
		open = false,
		fn = nil,
	},
	{
		title = "REPL_CONSOLE",
		open = false,
		fn = nil,
	},
	{
		title = "REPL_TROUBLE",
		open = false,
		fn = trouggle,
	},
	{
		title = "REPL",
		open = false,
		fn = nil,
	},
	{
		title = "REPL_LEFT_LOL",
		open = false,
		fn = function(open)
			if M.layouts[M.REPL_TROUBLE].open then
				M.layouts[M.REPL_TROUBLE].open = false
				dapui.close({ layout = M.REPL_TROUBLE })
			end
			if open then
				return dapui.open({ layout = M.REPL_LEFT_LOL })
			end
			dapui.close({ layout = M.REPL_LEFT_LOL })
		end,
	},

}

M.dapui_layouts = {
	{
		elements = {
			{ id = "scopes",      size = 0.50 },
			{ id = "breakpoints", size = 0.15 },
			{ id = "stacks",      size = 0.15 },
			{ id = "watches",     size = 0.10 },
		},
		size = 40,
		position = "left",
	},
	{ elements = { "repl", "console", }, size = 10, position = "bottom" },
	{ elements = { "repl" },             size = 20, position = "bottom" },
	{ elements = { "repl" },             size = 20, position = "bottom" },
	{ elements = { "repl" },             size = 40, position = "left" },
}

---@param layout layout_option
---@param open boolean
local function apply(layout, open)
	if not layout then return end
	local text = open and "open" or "close"
	local selected_layout = M.layouts[layout]
	vim.notify("Dap layout " .. text .. " " ..
		selected_layout.title, vim.log.levels.INFO, { timeout = 100 })
	selected_layout.open = open
	if selected_layout.fn then
		return selected_layout.fn(open)
	end
	if open then
		-- i don't even want to use their toggle
		return dapui.open({ layout = layout })
	end
	return dapui.close({ layout = layout })
end

---@param layout layout_option
---@return function()
function M.toggle_fn(layout)
	return function() return M.toggle(layout) end
end

---@param layout layout_option
function M.toggle(layout)
	return apply(layout, not M.layouts[layout].open)
end

---@param layout layout_option
function M.open(layout) return apply(layout, true) end

---@param layout layout_option
function M.close(layout) return apply(layout, false) end

return M
