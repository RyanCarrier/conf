vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.exrc = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
-- Enable mouse mode
vim.opt.mouse = 'a'
-- Sync clipboard between OS and Neovim.
-- i don't want this, but It's good to remember incase _y breaks?
-- vim.opt.clipboard = 'unnamedplus'
-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true
-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'
-- vim.opt.termguicolors = true
--scroll 8 lines before top/bottom
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"

-- smart indent will indent to expected on new line
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 4
--not suuuuper clear on this one though lol
vim.opt.isfname:append("@-@")
vim.opt.ff = "unix"
vim.opt.autoread = true

vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "indent-heuristic",
    "linematch:60",
    "algorithm:histogram",
}


--folding
vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep:.,foldclose:'
-- how many fold columns to show
vim.o.foldcolumn = '0'
-- vim.o.foldcolumn = 'auto:9'
vim.o.foldenable = true
-- lsp folding
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
-- idk
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
