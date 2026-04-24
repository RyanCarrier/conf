local M = {}
---@param node_type string
---@param goto_start boolean
function M.move_parent(node_type, goto_start)
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
        -- end_() returns exclusive end; convert to inclusive for nvim_win_set_cursor
        if col > 0 then
            col = col - 1
        else
            row = math.max(row - 1, 0)
            col = math.max(vim.fn.col({ row + 1, "$" }) - 1, 0)
        end
    end
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

return M
