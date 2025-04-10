local M = {}

-- apply a filter to the code actions
-- @param filter string
-- @return nil
local function filter_apply(filter)
	if require('modules.debug').enabled then vim.notify("Applying ca filter: " .. filter) end
	-- vim.notify(vim.inspect(vim.lsp.client().name))
	vim.lsp.buf.code_action({
		apply = true,
		filter = function(action)
			-- return string.find(string.lower(action.title), filter) ~= nil
			return string.lower(action.title) == filter
		end
	})
end

-- tbh just took this from the ca stuff in nvim
-- pre sure it's just being like yo here is the cursor position
local function make_position_param()
	local buf = vim.api.nvim_win_get_buf(0)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
	if not line then
		return { line = 0, character = 0 }
	end
	local _, col_encoded = vim.str_utfindex(line, col)
	return { line = row, character = col_encoded }
end

local function apply_to_codeactions(apply)
	local bufnr = 0
	local method = 'textDocument/codeAction'
	local position = make_position_param()
	local params = {
		textDocument = { uri = vim.uri_from_bufnr(bufnr) },
		range = { start = position, ['end'] = position },
		context = {
			triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
			diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr)
		}
	}
	return vim.lsp.buf_request_all(bufnr, method, params, apply)
end


-- count how many filter matches in ca results
local function count(results, filter)
	if filter == nil then return 0 end
	local found = 0
	for _, result in pairs(results) do
		for _, action in pairs(result.result or {}) do
			if string.find(action.title, filter) then
				found = found + 1
			end
		end
	end
	return found
end

function M.has_action(filter)
	filter = string.lower(filter)
	return apply_to_codeactions(function(results)
		for i, result in pairs(results) do
			for j, action in pairs(result.result or {}) do
				results[i].result[j].title = string.lower(action.title)
			end
		end
		return count(results, filter) > 0
	end)
end

--- Get the first code action that matches the filter
--- @param results table
--- @param filter string
--- @return string | nil
function M.get_first(results, filter)
	for _, result in pairs(results) do
		for _, action in pairs(result.result or {}) do
			if string.find(action.title, filter) then
				return action.title
			end
		end
	end
	return nil
end

--- Get the first code action that matches the filter
--- @param results table
--- @param filter string
--- @return string | nil
function M.get_matched_ca(results, filter)
	for _, result in pairs(results) do
		for _, action in pairs(result.result or {}) do
			if string.find(action.title, filter) then
				return action.title
			end
		end
	end
	return nil
end

--- Apply a filter to the code actions and run the first one that matches
--- the filter.
--- @param filters table<string> | string
--- @param apply_not_exact boolean | nil
---  if true, will apply the first code action even if it has more than 1 match
--- @return nil
function M.filter_apply(filters, apply_not_exact)
	if filters == nil then
		vim.notify("No filters provided")
		return
	end
	-- if filters is a string, convert it to a table
	if type(filters) == "string" then
		filters = { filters }
	end
	-- loop through filters and convert all to lower case
	for i, filter in ipairs(filters) do
		filters[i] = string.lower(filter)
	end
	-- at this point it should just be a table but idc
	-- local bufnr = vim.api.nvim_get_current_buf()
	-- vim.notify("Filtering code actions")

	if require('modules.debug').enabled then vim.notify("requesting filters;" .. vim.inspect(filters)) end
	apply_to_codeactions(function(results)
		-- vim.notify(vim.inspect(results))
		-- local all_actions = ""
		for i, result in pairs(results) do
			for j, action in pairs(result.result or {}) do
				results[i].result[j].title = string.lower(action.title)
				-- all_actions = all_actions .. action.title .. "\n"
			end
		end
		-- vim.notify("All actions:\n" .. all_actions)
		for _, filter in ipairs(filters) do
			local countResult = count(results, filter)
			-- vim.notify("Trying filter[" .. i .. "] " .. filter .. " matched " .. countResult)
			if countResult > 1 and apply_not_exact then
				-- local first = M.get_first(results, filter)
				-- if filter == nil then
				-- 	vim.notify("ERROR FILTER")
				-- 	return
				-- end
				-- filter = first or filter
				countResult = 1
			end
			if countResult == 1 then
				local first = M.get_first(results, filter)
				if filter == nil then
					vim.notify("ERROR FILTER")
					return
				end
				filter = first or filter
				-- if require('modules.debug').enabled then
				-- 	vim.notify("Applying exact Filter:\n" .. M.get_matched_ca(results, filter))
				-- end
				filter_apply(filter)
				return
			end
			if countResult > 2 then
				vim.notify("Too many matches for filter " .. filter .. " (" .. countResult .. " matches)")
			end
		end
		vim.notify("No action found")
	end)
end

--- return a function that would apply the filters and run the code action
--- @param filters table<string> | string
--- @param apply_not_exact boolean | nil
---  if true, will apply the first code action even if it has more than 1 match
---@return function <nil> The function that applies the filter to an array of values.
function M.filter_apply_fn(filters, apply_not_exact)
	-- vim.notify("Requesting filter fn " .. filters)
	return function() M.filter_apply(filters, apply_not_exact) end
end

return M
