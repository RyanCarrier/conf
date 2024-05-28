local M = {}
function M.nmap(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('n', keys, func, { desc = desc })
	-- vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
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
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('v', keys, func, { desc = desc })
end

return M
