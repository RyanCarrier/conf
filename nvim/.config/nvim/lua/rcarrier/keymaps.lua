vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'What did I last have open[?]' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        -- winblend = 10,
        -- previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>t?', require('telescope.builtin').commands, { desc = '[T]elescope commands[?]' })
vim.keymap.set('n', '<leader>th', require('telescope.builtin').command_history, { desc = '[T]elescope [H]istory' })
vim.keymap.set('n', '<leader>tr', require('telescope.builtin').resume, { desc = '[T]elescope [R]esume' })
vim.keymap.set('n', '<leader>tq', function()
    local ta = require('telescope.actions');
    -- test this, I want it to work while closed, but might need to go resume, send, close or something
    -- there is also a ta.open_qflist or smth
    ta.send_to_qflist()
end, { desc = '[T]elescope [R]esume' })

vim.keymap.set('n', '<leader>pg', require('telescope.builtin').git_files, { desc = '[P]roject [G]it files' })
vim.keymap.set('n', '<leader>pf', require('telescope.builtin').find_files, { desc = '[P]rojcet [F]iles' })
vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files,
    { desc = "[P]ersonal preference - idk this is from vscode and I'm use to it" })

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>tk', require('telescope.builtin').keymaps, { desc = '[T]elescope [K]eymaps' })

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '[[', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']]', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '((', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '))', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- make this next and prev error
-- vim.keymap.set('n', '[e', vim.diagnostic.goto_next, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

vim.keymap.set('n', '<space>ss', "<cmd>source ~/.config/nvim/lua/after/luasnip.lua<CR>", { desc = '[S]ource [S]nippets' })
local luasnip = require('luasnip')
vim.keymap.set({ "i", "s" }, "<C-s>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true, desc = "[S]nippets" })

vim.keymap.set("i", "<C-l>", function()
    -- if luasnip.choice_activate() then
    luasnip.change_choice(1)
    -- end
end, { desc = "Choice change snippet" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { noremap = true, silent = true, desc = "[U]ndo tree" })

vim.keymap.set('i', "<C-Del>", "<C-o>dw", { noremap = true })
-- ctrl backspace to delete word
vim.keymap.set('i', "<C-H>", "<C-W>", { noremap = true })

vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Centre screen after half jump" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Centre screen after half jump" })

vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = "[Y]ank to clipboard" })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = "[Y]ank to clipboard" })
vim.keymap.set('v', "<leader>p", [["_dP]], { desc = "[P]aste without overwriting register" })
-- TODO: we should make it so we can go <leader>p in 'n' and do select after (<leader>piw, to paste in word (or pib etc))

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = "delete to void" })
vim.keymap.set('v', '<leader>n', [[:norm!]], { desc = "Normal mode" })
vim.keymap.set('v', '<leader>s', [[:s/]], { desc = "Substitituter" })
vim.keymap.set('n', '<leader>s', [[:%s/]], { desc = "Substitituter" })
vim.keymap.set('n', "x", '"_x', { desc = "Delete without overwriting register", silent = true, noremap = true })
vim.keymap.set('n', "X", '"_X', { desc = "Delete without overwriting register", silent = true, noremap = true })

vim.keymap.set("n", "<C-q>", ":q<cr>", { desc = "[Q]uit" })
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', 'n', "nzzzv", { desc = "[n]ext but centered" })
vim.keymap.set('n', 'N', "Nzzzv", { desc = "[N]ext but centered" })

vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = 'chmod +x' })

-- need to learn about cnext and lnext
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
--
--
--
-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left, { desc = "Resize Left" })
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down, { desc = "Resize Down" })
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up, { desc = "Resize Up" })
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right, { desc = "Resize Right" })
-- moving between splits
vim.keymap.set('n', '<leader>h', require('smart-splits').move_cursor_left, { desc = "Move to" })
vim.keymap.set('n', '<leader>j', require('smart-splits').move_cursor_down, { desc = "Move to" })
vim.keymap.set('n', '<leader>k', require('smart-splits').move_cursor_up, { desc = "Move to" })
vim.keymap.set('n', '<leader>l', require('smart-splits').move_cursor_right, { desc = "Move to" })
-- swapping buffers between windows
vim.keymap.set('n', '<leader><A-h>', require('smart-splits').swap_buf_left, { desc = "Swap with" })
vim.keymap.set('n', '<leader><A-j>', require('smart-splits').swap_buf_down, { desc = "Swap with" })
vim.keymap.set('n', '<leader><A-k>', require('smart-splits').swap_buf_up, { desc = "Swap with" })
vim.keymap.set('n', '<leader><A-l>', require('smart-splits').swap_buf_right, { desc = "Swap with" })

-- remap increment/decrement (just inc)
-- (note that C-x dec)
vim.keymap.set("n", "<M-x>", "<C-a>")
vim.keymap.set('n', "vp", [[viw"_dP]], { desc = "paste in word" })

vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = "[G]it [S]tatus" })
vim.keymap.set('n', '<leader>gb', "<cmd>:Git blame<CR>", { desc = "[G]it [B]lame" })
vim.keymap.set('n', '<leader>gl', "<cmd>:Git log<CR>", { desc = "[G]it [L]og" })
vim.keymap.set('n', '<leader>gpp', "<cmd>:Git push<CR>", { desc = "[G]it [P]ush... ([P]lease)" })
vim.keymap.set('n', '<leader>gpl', "<cmd>:Git pull<CR>", { desc = "[G]it [P]ul[L]" })
vim.keymap.set('n', '<leader>gc', "<cmd>:Git checkout ", { desc = "[G]it [C]heckout" })
-- maybe do this stuff for git later
-- " fugitive git bindings
-- nnoremap <space>ga :Git add %:p<CR><CR>
-- nnoremap <space>gs :Gstatus<CR>
-- nnoremap <space>gc :Gcommit -v -q<CR>
-- nnoremap <space>gt :Gcommit -v -q %:p<CR>
-- nnoremap <space>gd :Gdiff<CR>
-- nnoremap <space>ge :Gedit<CR>
-- nnoremap <space>gr :Gread<CR>
-- nnoremap <space>gw :Gwrite<CR><CR>
-- nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
-- nnoremap <space>gp :Ggrep<Space>
-- nnoremap <space>gm :Gmove<Space>
-- nnoremap <space>gb :Git branch<Space>
-- nnoremap <space>go :Git checkout<Space>
-- nnoremap <space>gps :Dispatch! git push<CR>
-- nnoremap <space>gpl :Dispatch! git pull<CR>


vim.keymap.set('n', '<leader>dt', require('modules.debug').toggle, { desc = "[M]arkdown [P]review" })
vim.keymap.set('n', '<leader>mp', "<cmd>:MarkdownPreviewToggle<CR>", { desc = "[M]arkdown [P]review" })
-- [[ Basic Keymaps ]]
-- cnext, cprev
vim.keymap.set('n', '<leader>n', "<cmd>cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set('n', '<leader>N', "<cmd>cprev<CR>", { desc = "Prev quickfix" })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'g<leader>y', 'ggVG"+y', { desc = "Yank to clipboard" })

-- Test
local nmapt = function(keys, func, desc)
    if desc then desc = '[T]est ' .. desc end
    vim.keymap.set('n', keys, func, { desc = desc })
end
nmapt("<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, "[t]his File")
nmapt("<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, "[T]hese Files lol")
nmapt("<leader>tn", function() require("neotest").run.run({ strategy = "dap" }) end, "[N]earest")
nmapt("<leader>ts", require("neotest").summary.toggle, "Toggle Summary")
nmapt("<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, "Show Output")
nmapt("<leader>tO", require("neotest").output_panel.toggle, "Toggle Output Panel (VIEW ALL TESTS)")
nmapt("<leader>tS", require("neotest").run.stop, "Stop")

-- AI
local nmapai = function(keys, func, desc)
    if desc then desc = 'AI: ' .. desc end
    vim.keymap.set('n', keys, func, { desc = desc })
end
nmapai('<leader>ait', require("modules.ai.fim").toggle, "[AI] FIM [T]oggle")
