local M = {}
local copilot = require("modules.ai.copilot")
-- local supermaven = require("modules.ai.supermaven")
local codeium = require("modules.ai.codeium")
-- local providers = { copilot, supermaven, codeium }
local providers = { copilot, codeium }
local fim_keymaps = {
	accept = '<M-j>',
	accept_line = '<M-l>',
	next = '<M-;>',
	prev = "<M-'>",
	dismiss = "<M-h>",
	request = "<M-Space>",
}
M.local_copilot = false
M.activeIndex = 1
M.activeProvider = providers[M.activeIndex]

local function disabled()
	for _, provider in ipairs(providers) do
		if provider.enabled() then return false end
	end
	return true
end


local function unset_keymaps()
	if disabled() then
		return
	end
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
	local provider = M.activeProvider
	if not provider then return end
	imapai(fim_keymaps.accept_line, provider.accept_line, "Accept line suggestion")
	imapai(fim_keymaps.accept, provider.accept, "Accept suggestion")
	imapai(fim_keymaps.next, provider.next, "Next suggestion")
	imapai(fim_keymaps.prev, provider.prev, "Prev suggestion")
	imapai(fim_keymaps.dismiss, provider.dismiss, "Dismiss suggestion")
	imapai(fim_keymaps.request, provider.request, "Request completion suggestions")
end

function M.enable()
	if M.activeProvider then
		M.activeProvider.enable()
		set_keymaps()
		vim.notify(M.activeProvider.name .. ": enabled", vim.log.levels.INFO, { timeout = 2000, animate = false })
	else
		vim.notify("FIM disabled", vim.log.levels.INFO, { timeout = 2000, animate = false })
	end
end

function M.disable()
	if M.activeProvider then
		unset_keymaps()
		M.activeProvider.disable()
		if require("modules.debug").enabled then
			vim.notify(M.activeProvider.name .. ": disabled", vim.log.levels.INFO, { timeout = 2000, animate = false })
		end
	end
end

-- function M.toggle_local_copilot()
-- 	unset_keymaps()
-- 	if codeium.enabled() then
-- 		codeium.disable()
-- 		copilot.enable()
-- 	end
-- 	if M.local_copilot then
-- 		M.local_copilot = false
-- 		vim.g.copilot_proxy = nil
-- 		vim.g.copilot_proxy_strict_ssl = true
-- 	else
-- 		M.local_copilot = true
-- 		vim.g.copilot_proxy = "http://localhost:61107"
-- 		vim.g.copilot_proxy_strict_ssl = false
-- 	end
-- 	set_keymaps()
-- end

local function next_provider()
	-- allow provider index to overflow for disabled
	M.activeIndex = M.activeIndex > #providers and 1 or M.activeIndex + 1
	if require("modules.debug").enabled then vim.notify("providerIndex = " .. vim.inspect(M.activeIndex)) end
	if M.activeIndex > #providers then
		M.activeProvider = nil
	else
		M.activeProvider = providers[M.activeIndex]
	end
	if require("modules.debug").enabled then vim.notify("provider = " .. M.activeProvider.name) end
end

function M.init()
	M.enable()
end

function M.next_provider()
	M.disable()
	next_provider()
	M.enable()
end

return M
