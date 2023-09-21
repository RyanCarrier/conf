require('after.lsp.generic')
require('after.lsp.codeaction')
local rt = require("rust-tools")
vim.keymap.set("n", "<M-space>", rt.hover_actions.hover_actions,
	{ desc = "[H]over [A]ctions" })
-- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
-- Code action groups
-- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
vim.keymap.set("n", "<Leader>cg", rt.code_action_group.code_action_group,
	{ desc = "[C]ode [A]ction [G]roup" })

-- local qf = filter('Fix All')
-- nmap('<leader>fq', qf, '[F]ix... [Q]uick!')
-- nmap('<leader>q', qf, '[Q]uicky fixy')

local fix_import = function()
	filter_apply("Import `")
end
nmap('<leader>fi', fix_import, '[F]ix [I]mport')
nmap('<leader>fdi', function()
	vim.diagnostic.goto_next()
	fix_import()
end, '[F]ix [D]iagnostic [I]mport');
