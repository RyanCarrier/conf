-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank({
			timeout = 50,
		})
	end,
	group = highlight_group,
	pattern = '*',

})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- set formatter for json files to jq (need to format manually but whatever)
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "json",
-- 	command = "set formatprg=jq",
-- })
-- GIT STUFF FIGURE OUT LATER
local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = ThePrimeagen_Fugitive,
	pattern = "*",
	callback = function()
		-- print("help", vim.bo.ft)
		if vim.bo.ft ~= "fugitive" then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local opts = { buffer = bufnr, remap = false }
		print("great success", vim.bo.ft, bufnr, vim.inspect(opts))
		vim.keymap.set("n", "<leader>p", function()
			vim.cmd [[ Git push ]]
		end, opts)

		-- rebase always
		-- vim.keymap.set("n", "<leader>P", function()
		--   vim.cmd [[ Git pull --rebase ]]
		-- end, opts)

		-- NOTE: It allows me to easily set the branch i am pushing and any tracking
		-- needed if i did not set the branch up correctly
		-- vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
	end,
})
