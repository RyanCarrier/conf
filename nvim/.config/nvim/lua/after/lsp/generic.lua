function nmap(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

function nnomap(keys, func, desc)
	if desc then desc = 'LSP: ' .. desc end
	vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true, noremap = true })
end
