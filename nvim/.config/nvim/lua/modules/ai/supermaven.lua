local M = {}
local sm = require("supermaven-nvim.api")
M.name = "supermaven"
function M.enable()
	sm.start()
end

function M.disable()
	sm.stop()
end

function M.enabled()
	return sm.is_running()
end

function M.accept_line()
	local suggestion = require('supermaven-nvim.completion_preview')
	suggestion.on_accept_suggestion(true)
end

function M.accept()
	local suggestion = require('supermaven-nvim.completion_preview')
	suggestion.on_accept_suggestion()
end

function M.next()
	vim.notify(M.name .. ": next suggestion is not implemented yet", vim.log.levels.INFO,
		{ timeout = 500, animate = false })
end

function M.prev()
	vim.notify(M.name .. ": prev suggestion is not implemented yet", vim.log.levels.INFO,
		{ timeout = 500, animate = false })
end

function M.dismiss()
	local suggestion = require('supermaven-nvim.completion_preview')
	suggestion:dispose_inlay()
end

function M.request()
	vim.notify(M.name .. ": request suggestion is not implemented yet", vim.log.levels.INFO,
		{ timeout = 500, animate = false })
end

return M
