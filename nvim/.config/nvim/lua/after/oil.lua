local oil = require('oil')
oil.setup({
	view_options = {
		show_hidden = true,
	}
})
vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
