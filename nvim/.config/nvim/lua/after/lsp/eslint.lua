require('after.lsp.generic')
require('after.lsp.codeaction')

local qf = filter('Fix all')
nmap('<leader>fq', qf, '[F]ix... [Q]uick!')
nmap('<leader>q', qf, '[Q]uicky fixy')
local fi = filter("import")
nmap('<leader>fi', fi, '[F]ix [I]mport')
nmap('<leader>fdi', function()
	vim.diagnostic.goto_next()
	fi()
end, '[F]ix [D]iagnostic [I]mport');
