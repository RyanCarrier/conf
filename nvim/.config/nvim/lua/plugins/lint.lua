return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			dockerfile = { "hadolint" },
			["yaml.ghaction"] = { "actionlint" },
		}

		vim.filetype.add({
			pattern = {
				[".*/.github/workflows/.*%.yml"] = "yaml.ghaction",
				[".*/.github/workflows/.*%.yaml"] = "yaml.ghaction",
			},
		})

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
