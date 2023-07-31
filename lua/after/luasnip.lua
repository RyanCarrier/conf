local ls = require('luasnip')
local types = require('luasnip.util.types')

-- require('luasnip.loaders.from_vscode').load()
-- ls.setup({})
ls.config.set_config({
	history = false,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { " « ", "NonTest" } },
			},
		},
	},
})

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snips/*.lua", true)) do
	loadfile(ft_path)()
end
