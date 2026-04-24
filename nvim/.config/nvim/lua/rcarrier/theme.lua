local _border = "single"

vim.diagnostic.config({
  float = { border = _border },
})

-- expose border for use in on_attach keymaps
vim.g.lsp_float_border = _border
