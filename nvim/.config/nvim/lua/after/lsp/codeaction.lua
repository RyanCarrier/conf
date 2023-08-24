function filter_apply(filter)
	vim.lsp.buf.code_action({
		apply = true,
		filter = function(action)
			return string.find(action.title, filter)
		end
	})
end

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

function count(results, filter)
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

function filter_or_apply(filter1, filter2, filter3)
	-- local bufnr = vim.api.nvim_get_current_buf()
	local method = 'textDocument/codeAction'
	local position = make_position_param()
	local params = {
		textDocument = { uri = vim.uri_from_bufnr(bufnr or 0) },
		range = { start = position, ['end'] = position },
		context = {
			triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
			diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr)
		}
	}

	vim.lsp.buf_request_all(bufnr, method, params, function(results)
		if count(results, filter1) == 1 then
			filter_apply(filter1)
		end
		if count(results, filter2) == 1 then
			filter_apply(filter2)
		else
			filter_apply(filter3)
		end
	end)
end

-- cafilter to disgustingly code action filter
--  return a function so can be directly called with no issue
function filter(filter)
	return function() filter_apply(filter) end
end

function filter_or(filter1, filter2)
	return function() filter_or_apply(filter1, filter2) end
end
