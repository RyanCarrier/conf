require("rcarrier")
require("after")

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    -- winblend = 10,
    -- previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
-- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })

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
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '[[', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', ']]', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
-- add border to floating window
local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = _border
  }
)

vim.diagnostic.config {
  float = { border = _border }
}
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.keymap.set('n', "x", '"_x', { desc = "Delete without overwriting register", silent = true, noremap = true })
vim.keymap.set('n', "X", '"_X', { desc = "Delete without overwriting register", silent = true, noremap = true })

vim.keymap.set("n", "<C-q>", ":q<cr>", { desc = "[Q]uit" })
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', 'n', "nzzzv", { desc = "[n]ext but centered" })
vim.keymap.set('n', 'N', "Nzzzv", { desc = "[N]ext but centered" })

vim.keymap.set("n", "<leader>xc", "<cmd>!chmod +x %<CR>", { silent = true, desc = 'chmod +x' })

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
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<leader>h', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<leader>j', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<leader>k', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<leader>l', require('smart-splits').move_cursor_right)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><A-h>', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><A-j>', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><A-k>', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><A-l>', require('smart-splits').swap_buf_right)

-- this might be cool
vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")
vim.keymap.set("n", "<right>", "<C-w>l")
-- remap increment/decrement (just inc)
-- (note that C-x dec)
vim.keymap.set("n", "<M-x>", "<C-a>")
vim.keymap.set('n', "vp", [[viw"_dP]], { desc = "paste in word" })

vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = "[G]it [S]tatus" })


-- GIT STUFF FIGURE OUT LATER
local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = ThePrimeagen_Fugitive,
  pattern = "*",
  callback = function()
    -- print("help", vim.bo.ft)
    if vim.bo.ft ~= "fugitive" then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }
    print("great success", vim.bo.ft, bufnr, vim.inspect(opts))
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd [[ Git push ]]
    end, opts)

    -- rebase always
    -- vim.keymap.set("n", "<leader>P", function()
    --   vim.cmd [[ Git pull --rebase ]]
    -- end, opts)

    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
    -- needed if i did not set the branch up correctly
    -- vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
  end,
})


--TODO:
--ok heres the deal, we always qa....q,
--What about <C-a>....<C-a>🤯🤯🤯
-- because that's your tmux leader dummy
--then we go <A-a> to run
-- ok how about;
vim.keymap.set('n', '<C-1>', 'qa', { noremap = true, desc = 'Record macro to register a' })
vim.keymap.set('n', '<A-1>', '@a', { noremap = true, desc = 'Run macro reg a' })

if vim.g.neovide then
  -- scaling
  vim.g.neovide_scale_factor = 1
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(0.05)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(-0.05)
  end)
  -- pasting
  vim.keymap.set('i', '<C-S-v>', '<C-r>+', { noremap = true })

  -- gamer moments
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_scroll_animation_length = 0.1
  -- vim.g.neovide_profiler = true
  -- cursor
  vim.g.neovide_cursor_animation_length = 0.02
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_animate_command_line = true

  vim.o.guifont = "DejaVuSansM Nerd Font Mono:h10"
end
