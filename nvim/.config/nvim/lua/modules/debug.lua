local M = {}
M.enabled = false
M.toggle = function()
	M.enabled = not M.enabled
	vim.notify('Debug: ' .. (M.enabled and 'enabled' or 'disabled'))
end
return M
