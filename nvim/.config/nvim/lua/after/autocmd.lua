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
local fugugitiveGroup = vim.api.nvim_create_augroup("fugugitiveGroup", {})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = fugugitiveGroup,
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


vim.api.nvim_create_user_command('FormatToggle', function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	print('Setting autoformatting to: ' .. tostring(not vim.g.disable_autoformat))
end, {})

-- ensure eslint and dartls advertise formatting so conform's lsp fallback picks them up
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('lsp-format-capabilities', { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and (client.name == "eslint" or client.name == "dartls") then
			client.server_capabilities.documentFormattingProvider = true
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = {
		'Fastfile', 'Appfile', 'Matchfile', 'Pluginfile',
	},
	command = "set filetype=ruby",
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	pattern = "*",
	command = "checktime",
})
-- vim.api.nvim_create_autocmd({ "FileType" }, {
-- 	callback = function()
-- 		if require("nvim-treesitter.parsers").has_parser() then
-- 			vim.opt.foldmethod = "expr"
-- 			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- 		else
-- 			vim.opt.foldmethod = "syntax"
-- 		end
-- 	end,
-- })

-- Dart
-- if you use flutter-tools lspconfig.dartls.setup you don't need to.
local function reload_dartls_if_inactive()
	local dartls_client
	for _, client in ipairs(vim.lsp.get_clients()) do
		if client.name == "dartls" then
			dartls_client = client
			break
		end
	end

	vim.defer_fn(function()
		if dartls_client and not dartls_client.is_stopped() then
			return
		end

		if dartls_client and dartls_client.stop then
			dartls_client.stop()
		end
		vim.notify("Dart LSP is inactive, reloading...", vim.log.levels.INFO, { title = "Dart LSP" })

		require("flutter-tools.lsp").attach()
	end, 2000)
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.dart",
	callback = reload_dartls_if_inactive,
})



local onAttachGroup = vim.api.nvim_create_augroup("default-on-attach", {})
vim.api.nvim_create_autocmd(
	'LspAttach', {
		group = onAttachGroup,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client then
				require('after.lsp.on_attach').on_attach(client, args.buf)
			end
		end,
	})
