return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			ruby = { "rubyfmt" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			markdown = { "prettierd" },
			graphql = { "prettierd" },
			yaml = { "prettierd" },
			hcl = { "prettierd" },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
