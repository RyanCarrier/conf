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
	if #files == 0 then
		vim.notify('no custom snips for ' .. client.name .. " at " .. expected_path)
		return
	end
	for _, ft_path in ipairs(files) do
		if debug then vim.notify("loading: " .. vim.inspect(ft_path)) end
		loadfile(ft_path)()
		if debug then vim.notify("loaded: " .. vim.inspect(ft_path)) end
	end
end


function M.try_load(client)
	local debug = require('modules.debug').enabled
	if debug then
		vim.notify('Try load snips:' .. vim.inspect(client.name))
	end
	if not tableContains(has_custom_snips, client.name) then
		if debug then vim.notify('no custom snips') end
		return
	end
	if tableContains(M.loaded, client.name) then
		if debug then vim.notify('already loaded') end
		return
	end
	table.insert(M.loaded, client.name)
	load_snips(client)
end

function M.reload(client)
	load_snips(client)
end

return M
