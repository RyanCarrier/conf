local wk = require("which-key")
local chatgpt = require("chatgpt")
local gen = require("gen")
gen.prompts['Fix_Code'] = {
	prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
	replace = true,
	extract = "```$filetype\n(.-)```"
}
wk.register({
	a = {
		name = "[A]rtificial Intelligence",
		i = {
			name = "[AI]",
			i = {
				chatgpt.edit_with_instructions,
				"Edit with [I]nstructions",
			},
			f = {
				"<cmd>ChatGPTRun fix_bugs<CR>",
				"[AI] [F]ix bugs",
			},
			d = {
				"<cmd>ChatGPTRun docstring<CR>",
				"[AI] [D]ocstring",
			},
			g = {
				":Gen<CR>",
				"[AI] [G]en (ollama)",
			},
		}
	},
}, {
	prefix = "<leader>",
	mode = "v",
})

wk.register({
	a = {
		name = "[A]rtificial Intelligence",
		i = {
			name = "[AI]",
			-- set c in chatgpt so it's not bound if not initialized
			-- c = {
			-- 	chatgpt.openChat,
			-- 	"[AI] [C]hat",
			-- },
			p = {
				chatgpt.selectAwesomePrompt,
				"[AI] [P]rompt",
			},
			o = {
				":Gen Chat<CR>",
				"[AI] [O]llama Chat",
			},
			g = {
				":Gen<CR>",
				"[AI] [G]en (ollama)",
			},
			m = {
				gen.select_model,
				"[AI] Select [M]odel (ollama)",
			},
		},
	},
}, {
	prefix = "<leader>",
	mode = "n",
})
