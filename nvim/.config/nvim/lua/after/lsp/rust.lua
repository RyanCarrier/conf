local filter = require('after.lsp.codeaction').filter_apply_fn;
local lsp = require('after.lsp.generic');
local nmap = lsp.nmap;
local vmap = lsp.vmap;
local nmape = lsp.nmape;
local rt = require("rust-tools")
vim.keymap.set("n", "<M-space>", rt.hover_actions.hover_actions,
	{ desc = "[H]over [A]ctions" })
-- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
-- Code action groups
-- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
vim.keymap.set("n", "<Leader>cg", rt.code_action_group.code_action_group,
	{ desc = "[C]ode [A]ction [G]roup" })

local qf = filter('Fix All')
nmap('<leader>q', qf, '[Q]uicky fixy')

local fix_import = filter("Import `")
nmap('<leader>fi', fix_import, '[F]ix [I]mport')
nmap('<leader>fdi', function()
	vim.diagnostic.goto_next()
	fix_import()
end, '[F]ix [D]iagnostic [I]mport');

local wrap = function(with)
	-- haha this doens't work
	-- u will need to tresitter this
	return "F a" .. with .. "(<Esc>lf(%a)<Esc>h%"
end
nmap('<leader>wo', wrap("Ok"), '[W]rap [O]k')
nmap('<leader>we', wrap("Err"), '[W]rap [E]rr')
nmap('<leader>ws', wrap("Some"), '[W]rap [S]ome')
vmap("<leader>ws", "sa(hiSome<Esc>", "[W]rap [S]ome")
vmap("<leader>we", "sa(hiErr<Esc>", "[W]rap [E]rr")
vmap("<leader>wo", "sa(hiOk<Esc>", "[W]rap [O]k")
-- this needs to be tested lul
--
nmape('<leader>wd', 'mdf(%x`ddiwx', '[W]rap [D]elete')
