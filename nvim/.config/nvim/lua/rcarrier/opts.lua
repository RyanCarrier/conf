vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


vim.opt.exrc = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
-- Enable mouse mode
vim.opt.mouse = 'a'
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
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

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
