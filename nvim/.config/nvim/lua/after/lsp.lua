-- [[ Configure LSP ]]
local servers = {
	bashls = {},
	ruby_lsp = {},
	pyright = {},
	ts_ls = {},
	eslint = {
		enable = true,
		format = { enable = true },
		autoFixOnSave = true,
		codeActionOnSave = { enable = true, mode = "all" }
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

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = true,
})

for server_name, config in pairs(servers) do
	if next(config) then vim.lsp.config(server_name, config) end
	vim.lsp.enable(server_name)
end

vim.g.rustaceanvim = {
	tools = {},
	server = {
		default_settings = {
			['rust-analyzer'] = {},
		},
	},
	dap = {},
}
