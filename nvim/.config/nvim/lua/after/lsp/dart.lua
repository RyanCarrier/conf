local lspg = require('after.lsp.generic')
local nmap = lspg.nmap
local nvmap = lspg.nvmap
local filter = require('after.lsp.codeaction').filter_apply_fn;
local filter_apply = require('after.lsp.codeaction').filter_apply;
local has_action = require('after.lsp.codeaction').has_action;

function wrapWidget(newWidget)
	return function()
		-- this didn't work
		filter('Wrap with widget')
		vim.api.nvim_feedkeys("hciw" .. newWidget .. "<esc>", "n", false)
	end
end

nmap('<leader>ww', filter('Wrap with widget'), '[W]rap [W]idget')
lspg.nnomap('<leader>ws', wrapWidget("SingleChildScrollView"), '[W]rap [S]ingleChildScrollView')
lspg.nnomap('<leader>wf', wrapWidget("Flexible"), '[W]rap [F]exible')
nmap('<leader>wa', filter('Wrap with Align'), '[W]rap [A]lign')
nvmap('<leader>wr', filter('Wrap with Row'), '[W]rap [R]ow')
nvmap('<leader>wc', filter('Wrap with Col'), '[W]rap [C]olumn')
nmap('<leader>wp', filter('Wrap with Pad'), '[W]rap [P]adding')
nmap('<leader>fa', filter({ 'required argument', 'missing switch cases' }, true), '[F]ix required [A]rgument')

local qf = filter({ 'Fix All', 'Fix all' })
nmap('<leader>q', qf, '[Q]uicky fixy')

local fix_import = filter({
	"Import library 'dart:developer' with 'show'",
	"Import library '%.",
	"Import library 'package",
	"Import library 'dart",
	"Import library '.."
}, true)
nmap('<leader>fi', fix_import, '[F]ix [I]mport')
nmap('<leader>fdi', function()
	vim.diagnostic.goto_next()
	fix_import()
end, '[F]ix [D]iagnostic [I]mport');

-- TODO: use treesitter for this
nmap('<leader>we', "biExpanded(<CR>child: <Esc>f(%$i,)<Esc>%<Cmd>lua vim.lsp.buf.format()<CR>", '[W]rap [E]xpanded')
nmap('<C-,>', "F)i,<Esc>", 'COMMAAAAAA')

-- vim.keymap.set('v', '<leader>b', ":%norm! _3dwiexport '<Esc>A';", {
-- vim.keymap.set('n', '<leader>cb', ":%norm!_3dwiexport '<Esc>A';", {
-- vim.keymap.set('v', '<leader>b', ":%s/.*  \\(.*\\.dart\\)/export '\\1';", {
vim.keymap.set('n', '<leader>cb', [[:%s/.*  \(.*\.dart\)/export '\1';<CR>]], {
	noremap = true,
	silent = true,
	desc = '[B]arrel file fix'
})


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
