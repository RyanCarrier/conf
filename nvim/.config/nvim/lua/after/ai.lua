local wk = require("which-key")

-- AI stack reduced to copilot-only (FIM completions managed by modules.ai.fim).
-- Removed: chatgpt, gen (ollama), codeium, supermaven. avante disabled in plugins/ai/avante.lua.
wk.add(
	{
		{ "<leader>a",   group = "[A]rtificial Intelligence" },
		{ "<leader>ai",  group = "[AI]" },
		{ '<leader>ait', require("modules.ai.fim").next_provider, desc = "[AI] FIM [T]oggle" },
	})
