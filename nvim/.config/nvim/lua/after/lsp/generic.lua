local M = {}

local function map(mode, keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set(mode, keys, func, { desc = desc })
end

function M.nmap(keys, func, desc)
	map('n', keys, func, desc)
end

function M.nmape(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('n', keys, func, { desc = desc, expr = true })
end

function M.nnomap(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('n', keys, func, { desc = desc, silent = true, noremap = true })
end

function M.vmap(keys, func, desc)
	map('v', keys, func, desc)
end

function M.nvmap(keys, func, desc)
	return map({ 'n', 'v' }, keys, func, desc)
end

return M
