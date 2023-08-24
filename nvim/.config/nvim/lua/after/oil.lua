local oil = require('oil')
oil.setup({
	default_file_explorer = true,
	view_options = {
		show_hidden = true,
	},
	columns = {
		"icon",
	}
})
vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
