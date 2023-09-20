require('after.lsp.generic')
require('after.lsp.codeaction')


-- local qf = filter('Fix All')
-- nmap('<leader>fq', qf, '[F]ix... [Q]uick!')
-- nmap('<leader>q', qf, '[Q]uicky fixy')

local fix_import = function()
	filter_apply("Import `%.")
end
nmap('<leader>fi', fix_import, '[F]ix [I]mport')
nmap('<leader>fdi', function()
	vim.diagnostic.goto_next()
	fix_import()
end, '[F]ix [D]iagnostic [I]mport');
