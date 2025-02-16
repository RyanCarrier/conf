local lspg = require('after.lsp.generic')
local nmap = lspg.nmap
local nvmap = lspg.nvmap
local filter = require('after.lsp.codeaction').filter_apply_fn;
local filter_apply = require('after.lsp.codeaction').filter_apply;
local has_action = require('after.lsp.codeaction').has_action;

nmap('<leader>ww', filter('Wrap with widget'), '[W]rap [W]idget')
nvmap('<leader>wr', filter('Wrap with Row'), '[W]rap [R]ow')
nvmap('<leader>wc', filter('Wrap with Col'), '[W]rap [C]olumn')
nmap('<leader>wp', filter('Wrap with Pad'), '[W]rap [P]adding')
nmap('<leader>fa', filter({ 'required argument', 'missing switch cases' }, true), '[F]ix required [A]rgument')

local qf = filter({ 'Fix All', 'Fix all' })
nmap('<leader>q', qf, '[Q]uicky fixy')

local fix_import = filter({ "Import library 'dart:developer'", "Import library '%.", "Import library 'package",
	"Import library 'dart", "Import library '.." })
nmap('<leader>fi', fix_import, '[F]ix [I]mport')
nmap('<leader>fdi', function()
	vim.diagnostic.goto_next()
	fix_import()
end, '[F]ix [D]iagnostic [I]mport');

-- TODO: use treesitter for this
nmap('<leader>we', "biExpanded(<CR>child: <Esc>f(%$i,)<Esc>%<Cmd>lua vim.lsp.buf.format()<CR>", '[W]rap [E]xpanded')
nmap('<C-,>', "F)i,<Esc>", 'COMMAAAAAA')


--assuming we have a comma lol...
--otherwise we would only do 1x
--we are also assuming child is the last field lol
nmap('<leader>wd',
	function()
		if has_action('Remove this widget') then
			return filter_apply('Remove this widget', true)
		else
			return "f(%xx<C-o>bv/child<CR>wd"
		end
	end
	, '[W]rap [D]elete')
