local wk = require("which-key")
local chatgpt = require("chatgpt")
local gen = require("gen")
gen.prompts['Fix_Code'] = {
	prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
	replace = true,
	extract = "```$filetype\n(.-)```"
}
wk.add(
	{
		{
			mode = { "v" },
			{ "<leader>a",   group = "[A]rtificial Intelligence" },
			{ "<leader>ai",  group = "[AI]" },
			{ "<leader>aid", "<cmd>ChatGPTRun docstring<CR>",    desc = "[AI] [D]ocstring (CHATGPT)" },
			{ "<leader>aif", "<cmd>ChatGPTRun fix_bugs<CR>",     desc = "[AI] [F]ix bugs (CHATGPT)" },
			{ "<leader>aig", ":Gen<CR>",                         desc = "[AI] [G]en (ollama)" },
			{ "<leader>aii", chatgpt.edit_with_instructions,     desc = "Edit with [I]nstructions (CHATGPT)" },
		},
	})


wk.add(
	{
		{ "<leader>a",   group = "[A]rtificial Intelligence" },
		{ "<leader>ai",  group = "[AI]" },
		{ '<leader>ait', require("modules.ai.fim").next_provider, desc = "[AI] FIM [T]oggle" },
		{ "<leader>aig", ":Gen<CR>",                              desc = "[AI] [G]en (ollama)" },
		{ "<leader>aim", gen.select_model,                        desc = "[AI] Select [M]odel (ollama)" },
		{ "<leader>aio", ":Gen Chat<CR>",                         desc = "[AI] [O]llama Chat (ollama)" },
		{ "<leader>aip", chatgpt.selectAwesomePrompt,             desc = "[AI] [P]rompt (CHATGPT)" },
	})
