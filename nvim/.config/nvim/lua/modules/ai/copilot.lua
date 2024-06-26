local M = {}
function M.enable()
	vim.notify("Copilot enabled", vim.log.levels.INFO, { timeout = 500, animate = false })
	require("copilot.command").enable()
end

function M.disable()
	vim.notify("Copilot disabled", vim.log.levels.INFO, { timeout = 500, animate = false })
	require("copilot.command").disable()
end

function M.enabled()
	return not require("copilot.client").is_disabled()
end

function M.accept_line()
	require("copilot.suggestion").accept_line()
end

function M.accept()
	require("copilot.suggestion").accept()
end

function M.next()
	require("copilot.suggestion").next()
end

function M.prev()
	require("copilot.suggestion").prev()
end

function M.dismiss()
	require("copilot.suggestion").dismiss()
end

function M.request()
	return M.next()
end

return M
