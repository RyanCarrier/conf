require('after.luasnip')
require('after.oil')
-- require('after.nvim-tree')
require('after.theme-picker')
require('after.autocmd')
require('after.ai')

require('after.lsp')

require('tint').setup({
	saturation = 0.8,
	-- tint = -5,
	tint = -10,
})
require('modules.ai.fim').toggle()
