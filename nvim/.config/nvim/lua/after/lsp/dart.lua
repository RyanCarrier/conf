local nmap = require('after.lsp.generic').nmap
local filter = require('after.lsp.codeaction').filter_apply_fn;

nmap('<leader>ww', filter('Wrap with widget'), '[W]rap [W]idget')
nmap('<leader>wr', filter('Wrap with Row'), '[W]rap [R]ow')
nmap('<leader>wc', filter('Wrap with Col'), '[W]rap [C]olumn')
nmap('<leader>wp', filter('Wrap with Pad'), '[W]rap [P]adding')
nmap('<leader>fa', filter({ 'required argument', 'missing switch cases' }), '[F]ix required [A]rgument')

local qf = filter({ 'Fix All', 'Fix all' })
nmap('<leader>q', qf, '[Q]uicky fixy')

local fix_import = filter({ "Import library 'dart:developer'", "Import library '%.", "Import library 'package",
	"Import library 'dart" })
nmap('<leader>fi', fix_import, '[F]ix [I]mport')
nmap('<leader>fdi', function()
	vim.diagnostic.goto_next()
	fix_import()
end, '[F]ix [D]iagnostic [I]mport');

nmap('<leader>we', "biExpanded(<CR>child: <Esc>f(%$i,)<Esc>%<Cmd>lua vim.lsp.buf.format()<CR>", '[W]rap [E]xpanded')
nmap('<C-,>', "F)i,<Esc>", 'COMMAAAAAA')


--assuming we have a comma lol...
--otherwise we would only do 1x
--we are also assuming child is the last field lol
nmap('<leader>wd', 'f(%xx<C-o>bv/child<CR>wd', '[W]rap [D]elete')
vim.keymap.set("n", "<leader>fl", function()
	require("telescope").extensions.flutter.commands()
end, { desc = "[Fl]utter" })
vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRestart<cr>",
	{ desc = "[F]lutter [R]estart (not reload, just save a file bro)" })
vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<cr>",
	{ desc = "[F]lutter [Q]uit" })
