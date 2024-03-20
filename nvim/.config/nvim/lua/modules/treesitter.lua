local M = {}
---@param node_type string
---@param goto_start boolean
function M:move_parent(node_type, goto_start)
	local ts_utils = require("nvim-treesitter.ts_utils")
	local cur_node = ts_utils.get_node_at_cursor()
	while cur_node and cur_node:type() ~= node_type do
		cur_node = cur_node:parent()
	end

	if cur_node == nil then
		vim.notify("Couldn't find node of type " .. node_type)
		return
	end

	local goto_end = not goto_start
	local avoid_set_jump = false
	ts_utils.goto_node(cur_node, goto_end, avoid_set_jump)
end

return M
