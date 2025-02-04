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


-- Switch for controlling whether you want autoformatting.
--  Use :FormatToggle to toggle autoformatting on or off
local format_is_enabled = true
vim.api.nvim_create_user_command('FormatToggle', function()
	format_is_enabled = not format_is_enabled
	print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

-- Create an augroup that is used for managing our formatting autocmds.
--      We need one augroup per client to make sure that multiple clients
--      can attach to the same buffer without interfering with each other.
local _augroups = {}
local get_augroup = function(client)
	if not _augroups[client.id] then
		local group_name = 'lsp-format-' .. client.name
		local id = vim.api.nvim_create_augroup(group_name, { clear = true })
		_augroups[client.id] = id
	end
	return _augroups[client.id]
end

-- Whenever an LSP attaches to a buffer, we will run this function.
--
-- See `:help LspAttach` for more information about this autocmd event.
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('lsp-attach-format', { clear = true }),
	-- This is where we attach the autoformatting for reasonable clients
	callback = function(args)
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)
		local bufnr = args.buf
		-- if client.name == 'dartls' then
		--   return
		-- end
		if client == nil then
			vim.notify('client is nil')
			return
		end
		if client.name == "eslint" or client.name == "dartls" then
			client.server_capabilities.documentFormattingProvider = true
		end
		-- Only attach to clients that support document formatting
		if not client.server_capabilities.documentFormattingProvider then
			if require('modules.debug').enabled then vim.notify(client.name .. ' can not format') end
			return
		end
		--eslint instead yo
		if client.name == 'tsserver' then return end
		-- Create an autocmd that will run *before* we save the buffer.
		--  Run the formatting command for the LSP that has just attached.
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = get_augroup(client),
			buffer = bufnr,
			callback = function()
				if not format_is_enabled then
					if require('modules.debug').enabled then vim.notify(client.id .. ' format not enabled') end
					return
				end
				-- this does not work so it must be when saving is the issue
				-- if client.name == 'dartls' then
				--   vim.notify("not formatting dart")
				--   return
				-- end

				if require('modules.debug').enabled then vim.notify(client.name .. ' FORMATTING') end
				vim.lsp.buf.format({
					-- async = true,
					async = false,
					filter = function(c)
						return c.id == client.id
					end,
				})
				-- fix that dumbass bug when sometimes after format call diag will peace out
				-- if client.name == 'dartls' then vim.diagnostic.enable(bufnr) end
				--this didn't work either >.>
				if require('modules.debug').enabled then vim.notify(client.name .. ' FORMATED') end
			end,
		})
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
