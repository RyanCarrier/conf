require('after.lsp.generic')
require('after.lsp.codeaction')
-- local rt = require("rust-tools")
-- vim.keymap.set("n", "<M-space>", rt.hover_actions.hover_actions,
-- 	{ desc = "[H]over [A]ctions" })
-- -- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
-- -- Code action groups
-- -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
-- vim.keymap.set("n", "<Leader>cg", rt.code_action_group.code_action_group,
-- 	{ desc = "[C]ode [A]ction [G]roup" })

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

local wrap = function(with)
	-- haha this doens't work
	return "F a" .. with .. "(<Esc>lf(%a)<Esc>h%"
end
nmap('<leader>wo', wrap("Ok"), '[W]rap [O]k')
nmap('<leader>we', wrap("Err"), '[W]rap [E]rr')
nmap('<leader>ws', wrap("Some"), '[W]rap [S]ome')
vim.keymap.set('v', "<leader>ws", "sa(hiSome<Esc>", { desc = "[W]rap [S]ome", silent = true, noremap = true })
vim.keymap.set('v', "<leader>we", "sa(hiErr<Esc>", { desc = "[W]rap [E]rr", silent = true, noremap = true })
vim.keymap.set('v', "<leader>wo", "sa(hiOk<Esc>", { desc = "[W]rap [O]k", silent = true, noremap = true })
-- this needs to be tested lul
--
nmape('<leader>wd', 'T dt(lsd(', '[W]rap [D]elete')
