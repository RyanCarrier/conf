local lsp = require('after.lsp.generic');
local nmap = lsp.nmap;
local nvmap = lsp.nvmap;
local nnomap = lsp.nnomap;
local filter = require('after.lsp.codeaction').filter_apply_fn;
local M = {}
M.on_attach = function(client, bufnr)
	-- vim.notify('on_attach:' .. vim.inspect(client.name));
	local isDebug = require('modules.debug').enabled
	if isDebug then vim.notify(vim.inspect(client.name)) end
	require('after.lsp.codeaction')
	require('after.lsp.generic')

	if client.name == "rust_analyzer" or client.name == "rust-analyzer" then
		require('after.lsp.rust').init(bufnr)
	end
	if client.name == "dartls" then
		require('after.lsp.dart')
	end
	if client.name == "gopls" then
		nmap("<leader>ee", "oif err != nil {<CR>}<ESC>Oreturn err")

		local fix_import = filter("Add import:")
		nmap('<leader>fi', fix_import, '[F]ix [I]mport')
	end
	if client.name == "eslint" or client.name == "tsserver" then
		require('after.lsp.eslint')
	end

	-- open lsp log lol
	nmap('<leader>cl', function()
		vim.cmd('edit ' .. vim.lsp.get_log_path())
	end, '[C]hange [L]sp log, idk don\'t actually change it but like open it and leaderL is taken')
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nvmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

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

	nmap('<leader>ff', function()
		if isDebug then
			vim.notify('Formatting with ' .. vim.inspect(vim.lsp.client.name))
		end
		vim.lsp.buf.format()
	end, '[FF]ormat')
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
	nmap('<leader>wli', "<CMD>LspInfo<CR>", '[W]orkspace [L]sp[I]nfo')
	nmap('<leader>wlr', "<CMD>LspRestart<CR>", '[W]orkspace [L]sp[R]estart')
	nmap('<leader>wll', function()
		vim.diagnostic.setloclist()
	end, '[W]orkspace [L]oc[L]ist')
	nmap('<leader>wql', function()
		vim.diagnostic.setqflist()
	end, '[W]orkspace [Q]uickfix[L]ist')
	nmap('<leader>dve', function()
		vim.diagnostic.config({
			virtual_text = true,
		})
	end
	, '[D]iagnostic [V]irtual Text [E]nable')
	nmap('<leader>dvd', function()
		vim.diagnostic.config({
			virtual_text = false,
		})
	end
	, '[D]iagnostic [V]irtual Text [D]isable ahhahahaah toggle')
	require('after.lsp.dap')
	local snips = require('modules.snips')
	if snips.has_custom_snips(client) then
		vim.keymap.set('n', '<space>ss', function()
			snips.reload(client)
		end, { desc = '[S]ource [S]nippets' })
		snips.try_load(client)
	end
end
return M
