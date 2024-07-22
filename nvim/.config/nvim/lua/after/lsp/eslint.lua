local nmap = require('after.lsp.generic').nmap;
local filter = require('after.lsp.codeaction').filter_apply_fn

local qf = filter({ 'Fix All', 'Fix all' })
nmap('<leader>q', qf, '[Q]uicky fixy')
local fi = filter("import")
nmap('<leader>fi', fi, '[F]ix [I]mport')
nmap('<leader>fdi', function()
	vim.diagnostic.goto_next()
	fi()
end, '[F]ix [D]iagnostic [I]mport');
