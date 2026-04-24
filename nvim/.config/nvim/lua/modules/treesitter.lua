local M = {}
---@param node_type string
---@param goto_start boolean
function M:move_parent(node_type, goto_start)
    local cur_node = vim.treesitter.get_node()
    while cur_node and cur_node:type() ~= node_type do
        cur_node = cur_node:parent()
    end

    if cur_node == nil then
        vim.notify("Couldn't find node of type " .. node_type)
        return
    end

    local row, col
    if goto_start then
        row, col = cur_node:start()
    else
        row, col = cur_node:end_()
    end
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

return M
