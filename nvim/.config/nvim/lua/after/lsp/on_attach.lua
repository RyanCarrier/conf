local M = {}
M.on_attach = function(client, bufnr)
	-- vim.notify('on_attach:' .. vim.inspect(client.name));
	vim.notify(vim.inspect(client.name));

	require('after.lsp.codeaction')
	require('after.lsp.generic')

	if client.name == "rust_analyzer" then
		require('after.lsp.rust')
	end
	if client.name == "dartls" then
		require('after.lsp.dart')
	end
	if client.name == "gopls" then
		nmap("<leader>ee", "oif err != nil {<CR>}<ESC>Oreturn err")
	end
	if client.name == "eslint" or client.name == "tsserver" then
		require('after.lsp.eslint')
	end

	-- open lsp log lol
	nmap('<leader>cl', function()
		vim.cmd('edit ' .. vim.lsp.get_log_path())
	end, '[C]hange [L]sp log, idk don\'t actually change it but like open it and leaderL is taken')
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', function() vim.lsp.buf.definition() end, '[G]oto [D]efinition')
	nmap('gsd', function()
		-- create a vertical split
		vim.api.nvim_command("split")
		-- jump to the new split
		vim.api.nvim_command("wincmd j")
		vim.lsp.buf.definition()
	end, '[G]oto [D]efinition with a [S]plit')
	nnomap('gvd', function()
		-- create a vertical split
		vim.api.nvim_command("vsplit")
		-- jump to the new split
		vim.api.nvim_command("wincmd l")
		vim.lsp.buf.definition()
	end, '[G]oto [D]efinition with a [S]plit')

	nmap('gr', function()
		require('telescope.builtin').lsp_references({
			include_declaration = false,
		})
	end, '[G]oto [R]eferences')
	nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>wOs', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[WO]rkspace [S]ymbols')

	nmap('<leader>ff', vim.lsp.buf.format, '[FF]ormat')
	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	-- REMOVED to allow for j and k
	-- I don't think this does need to be removed (it doesn't, C-k is used in insert mode for selection, not normal)
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wOa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wOd', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [D]elete Folder')
	nmap('<leader>wOl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')
end
return M
