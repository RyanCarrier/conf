function nmap(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

function nmape(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, expr = true })
end

function nnomap(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true, noremap = true })
end

function vmap(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('v', keys, func, { buffer = bufnr, desc = desc })
end
