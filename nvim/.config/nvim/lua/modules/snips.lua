local M = {}

local has_custom_snips = { "dartls", "rust-analyzer" }
M.loaded = {}

local function tableContains(table, value)
	for i = 1, #table do
		if (table[i] == value) then
			return true
		end
	end
	return false
end


local function load_snips(client)
	local debug = require('modules.debug').enabled
	local expected_path = 'lua/snips/' .. client.name .. '.lua';
	local files = vim.api.nvim_get_runtime_file(expected_path, true)
	local loaded = false
	if #files == 0 then
		vim.notify('no custom snips for ' .. client.name .. " at " .. expected_path)
		return loaded
	end
	for _, ft_path in ipairs(files) do
		if debug then vim.notify("loading: " .. vim.inspect(ft_path)) end
		loadfile(ft_path)()
		loaded = true
		if debug then vim.notify("loaded: " .. vim.inspect(ft_path)) end
	end
	return loaded
end


--- Try to load custom snippets for a client
--- @param client table
--- @return boolean if snippets were loaded
function M.try_load(client)
	local debug = require('modules.debug').enabled
	if debug then
		vim.notify('Try load snips:' .. vim.inspect(client.name))
	end
	if not tableContains(has_custom_snips, client.name) then
		if debug then vim.notify('no custom snips') end
		return false
	end
	if tableContains(M.loaded, client.name) then
		if debug then vim.notify('already loaded') end
		return false
	end
	table.insert(M.loaded, client.name)
	return load_snips(client)
end

function M.reload(client)
	load_snips(client)
end

--- Check if a client has custom snippets
--- @param client table
--- @return boolean
function M.has_custom_snips(client)
	return tableContains(has_custom_snips, client.name)
end

return M
