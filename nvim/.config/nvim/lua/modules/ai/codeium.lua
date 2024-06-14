local M = {}

function M.enable()
	vim.notify("Codeium enabled", vim.log.levels.INFO, { timeout = 500, animate = false })
	vim.g.codeium_enabled = true
end

function M.disable()
	vim.notify("Codeium disabled", vim.log.levels.INFO, { timeout = 500, animate = false })
	vim.g.codeium_enabled = false
end

function M.enabled()
	return vim.g.codeium_enabled
end

function M.accept_line()
	return vim.fn['codeium#Accept']()
end

function M.accept()
	return vim.fn['codeium#Accept']()
end

function M.next()
	return vim.fn['codeium#CycleCompletions'](1)
end

function M.prev()
	return vim.fn['codeium#CycleCompletions'](-1)
end

function M.dismiss()
	return vim.fn['codeium#Clear']()
end

function M.request()
	return vim.fn['codeium#Complete']()
end

return M
