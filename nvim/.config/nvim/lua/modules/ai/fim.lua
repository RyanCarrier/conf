local M = {}
local copilot = require("modules.ai.copilot")
local codeium = require("modules.ai.codeium")
local fim_keymaps = {
	accept = '<M-j>',
	accept_line = '<M-l>',
	next = '<M-;>',
	prev = "<M-'>",
	dismiss = "<M-h>",
	request = "<M-Space>",
}
M.local_copilot = false

local function active()
	if copilot.enabled() then
		return copilot
	else
		if codeium.enabled() then
			return codeium
		else
			return nil
		end
	end
end

local function disabled() return not codeium.enabled() and not copilot.enabled() end

local function unset_keymaps()
	if disabled() then return end
	for _, key in pairs(fim_keymaps) do
		vim.keymap.del('i', key, { noremap = true, silent = true })
	end
end

local function set_keymaps()
	if disabled() then return end
	local imapai = function(keys, func, desc)
		if desc then desc = 'AI: ' .. desc end
		vim.keymap.set('i', keys, func, { desc = desc, noremap = true, expr = codeium.enabled() })
	end
	imapai(fim_keymaps.accept_line, active().accept_line, "Accept line suggestion")
	imapai(fim_keymaps.accept, active().accept, "Accept suggestion")
	imapai(fim_keymaps.next, active().next, "Next suggestion")
	imapai(fim_keymaps.prev, active().prev, "Prev suggestion")
	imapai(fim_keymaps.dismiss, active().dismiss, "Dismiss suggestion")
	imapai(fim_keymaps.request, active().request, "Request completion suggestions")
end
function M.toggle_local_copilot()
	unset_keymaps()
	if codeium.enabled() then
		codeium.disable()
		copilot.enable()
	end
	if M.local_copilot then
		M.local_copilot = false
		vim.g.copilot_proxy = nil
		vim.g.copilot_proxy_strict_ssl = true
	else
		M.local_copilot = true
		vim.g.copilot_proxy = "http://localhost:61107"
		vim.g.copilot_proxy_strict_ssl = false
	end
	set_keymaps()
end

function M.toggle()
	unset_keymaps()
	if copilot.enabled() then
		copilot.disable()
		codeium.enable()
	else
		if codeium.enabled() then
			codeium.disable()
		else
			copilot.enable()
		end
	end
	set_keymaps()
end

return M
