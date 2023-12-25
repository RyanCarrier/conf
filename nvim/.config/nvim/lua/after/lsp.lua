-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
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
		local qf = filter('Fix all')
		nmap('<leader>fq', qf, '[F]ix... [Q]uick!')
		nmap('<leader>q', qf, '[Q]uicky fixy')
		local fi = filter("import")
		nmap('<leader>fi', fi, '[F]ix [I]mport')
		nmap('<leader>fdi', function()
			vim.diagnostic.goto_next()
			fi()
		end, '[F]ix [D]iagnostic [I]mport');
	end

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
	-- vim.keymap.set('n', 'gvff', function()
	-- 	-- create a vertical split
	-- 	vim.api.nvim_command("vsplit")
	-- 	-- jump to the new split
	-- 	vim.api.nvim_command("wincmd l")
	-- 	require('telescope.builtin').find_files()
	-- end, { desc = 'JAMES' })

	nmap('gr', function()
		require('telescope.builtin').lsp_references({
			-- it pays to know how to spell declaration
			include_declaration = false,
		})
	end, '[G]oto [R]eferences')
	-- nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
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
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	rust_analyzer = {
		format = { enable = true },
	},
	pyright = {},
	move_analyzer = {},
	tsserver = {
		format = { enable = false },
	},
	eslint = {
		enable = true,
		format = { enable = true }, -- this will enable formatting
		autoFixOnSave = true,
		codeActionOnSave = { enable = true, mode = "all" }
	},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
	automatic_installation = true,
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
})
require('flutter-tools').setup({
	lsp = {
		on_attach = on_attach,
	}
})
require('rust-tools').setup({
	server = {
		on_attach = on_attach,
	},
})
