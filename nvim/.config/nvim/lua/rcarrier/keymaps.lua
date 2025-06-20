local t_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><space>', t_builtin.buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    t_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({}))
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p", { desc = "Yank and comment" })

vim.keymap.set('n', '<leader>t?', t_builtin.commands, { desc = '[T]elescope commands[?]' })
vim.keymap.set('n', '<leader>th', t_builtin.command_history, { desc = '[T]elescope [H]istory' })
vim.keymap.set('n', '<leader>tr', t_builtin.resume, { desc = '[T]elescope [R]esume' })
vim.keymap.set('n', '<leader>tq', function()
    local ta = require('telescope.actions');
    -- test this, I want it to work while closed, but might need to go resume, send, close or something
    -- there is also a ta.open_qflist or smth
    ta.send_to_qflist()
end, { desc = '[T]elescope [Q]uestion what i made this for idk' })


vim.keymap.set('n', '<leader>pg', t_builtin.git_files, { desc = '[P]roject [G]it files' })
vim.keymap.set('n', '<leader>pf', t_builtin.find_files, { desc = '[P]rojcet [F]iles' })
vim.keymap.set('n', '<C-p>', t_builtin.git_files,
    { desc = "[P]ersonal preference - idk this is from vscode and I'm use to it" })
vim.keymap.set('n', '<leader>sh', t_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', t_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', t_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', t_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>tk', t_builtin.keymaps, { desc = '[T]elescope [K]eymaps' })

-- Diagnostic keymaps
vim.keymap.set('n', '((', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '))', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- make this next and prev error
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

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
vim.keymap.set({ 'n', 'v' }, '<leader>n', [[:norm!]], { desc = "Normal mode" })
vim.keymap.set('v', '<leader>s', [[:s/]], { desc = "Substitituter" })
vim.keymap.set('n', '<leader>ss', [[:%s/]], { desc = "Substitituter" })
vim.keymap.set('n', "x", '"_x', { desc = "Delete without overwriting register", silent = true, noremap = true })
vim.keymap.set('n', "X", '"_X', { desc = "Delete without overwriting register", silent = true, noremap = true })

vim.keymap.set("n", "<C-q>", ":q<cr>", { desc = "[Q]uit" })
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', 'n', "nzzzv", { desc = "[n]ext but centered" })
vim.keymap.set('n', 'N', "Nzzzv", { desc = "[N]ext but centered" })

vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = 'chmod +x' })

-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
local smart_splits = require('smart-splits')
vim.keymap.set('n', '<A-h>', smart_splits.resize_left, { desc = "Resize Left" })
vim.keymap.set('n', '<A-j>', smart_splits.resize_down, { desc = "Resize Down" })
vim.keymap.set('n', '<A-k>', smart_splits.resize_up, { desc = "Resize Up" })
vim.keymap.set('n', '<A-l>', smart_splits.resize_right, { desc = "Resize Right" })
-- moving between splits
vim.keymap.set('n', '<leader>h', smart_splits.move_cursor_left, { desc = "Move to" })
vim.keymap.set('n', '<leader>j', smart_splits.move_cursor_down, { desc = "Move to" })
vim.keymap.set('n', '<leader>k', smart_splits.move_cursor_up, { desc = "Move to" })
vim.keymap.set('n', '<leader>l', smart_splits.move_cursor_right, { desc = "Move to" })
-- swapping buffers between windows
vim.keymap.set('n', '<leader><A-h>', smart_splits.swap_buf_left, { desc = "Swap with" })
vim.keymap.set('n', '<leader><A-j>', smart_splits.swap_buf_down, { desc = "Swap with" })
vim.keymap.set('n', '<leader><A-k>', smart_splits.swap_buf_up, { desc = "Swap with" })
vim.keymap.set('n', '<leader><A-l>', smart_splits.swap_buf_right, { desc = "Swap with" })

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

vim.keymap.set('n', '<leader>gtw', require('gitsigns').toggle_word_diff, { desc = "[G]it [T]oggle [W]ord diff" })
vim.keymap.set('n', '<leader>gtl', require('gitsigns').toggle_linehl, { desc = "[G]it [T]oggle [L]ine diff" })
vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { desc = "[G]it [H]unk preview" })
vim.keymap.set('n', '<leader>gd', "<cmd>DiffviewOpen<CR>", { desc = "[G]it [D]iff" })
vim.keymap.set('n', '<leader>gmd',
    function() vim.cmd('DiffviewOpen main') end
    , { desc = "[G]it [M]ain [D]iff (local) (DiffviewOpen main)" })
vim.keymap.set('n', '<leader>gMd',
    function() vim.cmd('DiffviewOpen HEAD..origin/main') end
    , { desc = "[G]it [M]ain [D]iff (remote)" })
vim.keymap.set('n', '<leader><leader>v',
    function() if next(require('diffview.lib').views) == nil then vim.cmd('DiffviewOpen') else vim.cmd('DiffviewClose') end end)



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


vim.keymap.set('n', '<leader>dt', require('modules.debug').toggle, { desc = "(nvim) [D]ebug [T]oggle" })
vim.keymap.set('n', '<leader>mp', "<cmd>:MarkdownPreviewToggle<CR>", { desc = "[M]arkdown [P]review" })
-- [[ Basic Keymaps ]]
-- cnext, cprev
-- revisit this
-- vim.keymap.set('n', '<leader>n', "<cmd>cnext<CR>", { desc = "Next quickfix" })
-- vim.keymap.set('n', '<leader>N', "<cmd>cprev<CR>", { desc = "Prev quickfix" })
-- need to learn about cnext and lnext
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

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
local nt = require('neotest')
nmapt("<leader>tT", function() nt.run.run(vim.fn.expand("%")) end, "[T]his File")
-- nmapt("<leader>tT", function() nt.run.run(vim.loop.cwd()) end, "[T]hese Files lol")
nmapt("<leader>tn", function() nt.run.run({ strategy = "dap" }) end, "[N]earest")
nmapt("<leader>ts", nt.summary.toggle, "Toggle Summary")
nmapt("<leader>to", function() nt.output.open({ enter = true, auto_close = true }) end, "Show Output")
nmapt("<leader>tO", nt.output_panel.toggle, "Toggle Output Panel (VIEW ALL TESTS)")
nmapt("<leader>tS", nt.run.stop, "Stop")
nmapt(")t", nt.jump.next, "Next [t]est")
nmapt("(t", nt.jump.prev, "Prev [t]est")
nmapt(")f", function() nt.jump.next({ status = "failed" }) end, "Next [f]ailed test")
nmapt("(f", function() nt.jump.prev({ status = "failed" }) end, "Prev [f]ailed test")

vim.keymap.set('n', '<leader>to', '<cmd>TodoTelescope<cr>',
    { desc = "[To]do list", silent = true, noremap = true })

vim.keymap.set({ "v", "n" }, "<leader>cp", require("actions-preview").code_actions,
    { desc = "[C]ode actions [P]review" })
vim.keymap.set('n', '<leader>cc', "<cmd>checktime<cr>", { desc = '[c]hecktime' })
vim.keymap.set('n', '<leader>csv', require('csvview').toggle, { desc = '[csv]view' })
local pa = require('pubspec-assist');
vim.keymap.set("n", "<leader>pal", function() pa.set_latest_version() end);
vim.keymap.set("n", "<leader>pap", function() pa.open_version_picker() end);


vim.keymap.set('n', '<leader>pwd', function()
    local filepath = vim.fn.expand('%')
    vim.fn.setreg('+', filepath) -- write to clippoard end
end, { noremap = true, silent = true, desc = "[P]ut(rint) [W]orking [D]irectory (file in clipboard)" })
vim.keymap.set('n', '<leader>gwd', ":e <C-r>+<CR>",
    { noremap = true, desc = "[G]o [W]orking [D]irectory (file in clipboard)" })

-- zv to toggle fold column
vim.keymap.set('n', 'zv', function()
    vim.o.foldcolumn = vim.o.foldcolumn == '0' and '1' or '0'
end, { desc = "Toggle fold column" })

vim.keymap.set('n', '<leader>wih',
    function()
        vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled(
            --{ bufnr = bufnr }
                {}),
            {}
        --{ bufnr = bufnr }
        )
    end, { desc = "[W]orkspace [I]nlay [H]ints (toggle)" })

-- tabs
local wk = require("which-key")
wk.add(
    {
        {
            mode = { "n" },
            { "<leader>tt",  group = "[T]ab [T]ab" },
            { "<leader>ttn", "<cmd>tabnext<CR>",     desc = "[T]ab [N]ext" },
            { "<leader>ttN", "<cmd>tabnew<CR>",      desc = "[T]ab [N]ew" },
            { "<leader>ttp", "<cmd>tabprevious<CR>", desc = "[T]ab [P]revious" },
            { "<leader>ttc", "<cmd>tabclose<CR>",    desc = "[T]ab [C]lose" },
        },
    })
local o = require('overseer')
wk.add(
    {
        {
            mode = { "n" },
            { "<leader>ta",  group = "[Ta]sks" },
            { "<leader>taa", o.run_template,   desc = "[Ta]sks [A]ll" },
            { "<leader>tao", o.toggle,         desc = "[Ta]sks [O]pen" },
        },
    })
local t = require('trouble')
-- local trouble_next = function() t.next({ skip_groups = true, jump = true }) end
local trouble_next = function()
    t.next()
    t.jump_only()
    -- get default trouble window
    -- t.next({ mode = "lsp_workspace_diagnostics" }, { opts = { jump = true } })
    -- t.next({ opts = { jump = true } })
    -- t.open
end;
-- Lua
nmapt = function(input, cmd, desc)
    vim.keymap.set("n", input, cmd, { desc = "[Trouble] " .. desc })
end
wk.add({ {
    mode = { "n" },
    { "<leader>x",  group = "[Trouble]" },
    { "<leader>xx", t.close,            desc = "Toggle" },
    {
        "<leader>xw",
        function()
            t.close()
            t.open({ mode = "diagnostics_workspace" })
        end,
        desc = "Workspace diagnostics",
    },
    {
        "<leader>xd",
        function()
            t.close()
            t.open({ mode = "diagnostics_buffer" })
        end,
        desc = "Document diagnostics",
    },
} })
vim.keymap.set('n', '<C-t>', trouble_next, { silent = true, noremap = true, desc = "Trouble next" })
-- nmap("gR", "lsp_references", "LSP references")
wk.add({ {
    mode = { "n", "v" },
    { "<leader>T", group = "[T]odo (markdown checkmate.nvim)" },
    -- { "<leader>TT", "<CMD>:CheckmateToggle<CR>",               { desc = "[T]odo [T]oggle" } },
    -- { "<leader>Tc", "<CMD>:CheckmateCreate<CR>",               { desc = "[T]odo [C]reate" } },
} });
