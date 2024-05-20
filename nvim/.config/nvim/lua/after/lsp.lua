-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = require('after.lsp.on_attach').on_attach
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	bashls = {},
	rust_analyzer = {
		format = { enable = true },
	},
	pyright = {},
	-- move_analyzer = {},
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
-- require('flutter-tools').setup({
-- 	lsp = {
-- 		on_attach = on_attach,
-- 	}
-- })
require('rust-tools').setup({
	server = {
		on_attach = on_attach,
	},
})
