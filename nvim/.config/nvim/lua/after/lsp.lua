local servers = {
	bashls = {},
	ruby_lsp = {},
	pyright = {},
	ts_ls = {},
	eslint = {
		settings = {
			validate = 'on',
			format = true,
			codeActionOnSave = { enable = true, mode = "all" },
			run = 'onType',
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
	taplo = {},
}

vim.lsp.config('*', {
	capabilities = require('blink.cmp').get_lsp_capabilities(),
})

for server_name, config in pairs(servers) do
	if next(config) then vim.lsp.config(server_name, config) end
end

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = true,
})
