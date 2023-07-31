require("rcarrier")
require("after")

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',

})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
      -- n = {},
    },
  },
})
require("telescope").setup({
  pickers = {
    colorscheme = {
      enable_preview = true
    }
  }
})



-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
-- See `:help telescope.builtin`
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

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'bash', 'dart',
    'zig', 'toml', 'yaml', 'gomod', },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself! )
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python', 'dart' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        -- lol
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
})




-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- make this next and prev error
-- vim.keymap.set('n', '[e', vim.diagnostic.goto_next, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end
  local nnomap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true, noremap = true })
  end
  -- cafilter to disgustingly code action filter
  --  return a function so can be directly called with no issue
  local cafilter = function(filter)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        filter = function(action)
          return string.find(action.title, filter)
        end
      })
    end
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('<leader>ww', cafilter('Wrap with widget'), '[W]rap [W]idget')
  nmap('<leader>wr', cafilter('Wrap with Row'), '[W]rap [R]ow')
  nmap('<leader>wc', cafilter('Wrap with Col'), '[W]rap [C]olumn')
  nmap('<leader>wp', cafilter('Wrap with Pad'), '[W]rap [P]adding')
  -- mostly cause I've gotten semi use to C-Q, and idk how much i love the trouble extension
  nmap('<leader>fq', cafilter('Fix All'), '[F]ix... [Q]uick!')
  nmap('<leader>q', cafilter('Fix All'), '[Q]uicky fixy')
  nmap('<leader>fi', cafilter("Import library 'package"), '[F]ix [I]mport')

  nmap('gd', function() vim.lsp.buf.definition({ reuse_win = true }) end, '[G]oto [D]efinition')
  nmap('gsd', function()
    -- create a vertical split
    vim.api.nvim_command("split")
    -- jump to the new split
    vim.api.nvim_command("wincmd j")
    vim.lsp.buf.definition()
  end, '[G]oto [D]efinition with a [S]plit')
  nnomap('gvd', function()
    -- create a vertical split
    vim.api.nvim_command("vsplit")
    -- jump to the new split
    vim.api.nvim_command("wincmd l")
    vim.lsp.buf.definition()
  end, '[G]oto [D]efinition with a [S]plit')
  nmap('gr', function()
    require('telescope.builtin').lsp_references({
      -- it pays to know how to spell declaration
      include_declaration = false,
    })
  end, '[G]oto [R]eferences')
  -- nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>ff', vim.lsp.buf.format, '[FF]ormat')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- REMOVED to allow for j and k
  -- I don't think this does need to be removed (it doesn't, C-k is used in insert mode for selection, not normal)
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wd', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [D]elete Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')


  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  move_analyzer = {},
  -- tsserver = {},
  -- eslint = {},


  --flutter-tools maybe set lsp here, that probably would work? idk
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
})
-- I already have attach done in flutter toosl setup, pretty sure it's all auto
-- don't need to use the custom on_attach
-- ok seems like I do need it, maybe move config to here then lol
-- (probably don't actually need it, just that all the keymaps are applied on the 'on_attach')
require('flutter-tools').setup({
  lsp = {
    on_attach = on_attach,
  }
})
require('rust-tools').setup({
  server = {
    on_attach = on_attach,
  },
})

-- this should probably be done correctly...
local wk = require("which-key")
local chatgpt = require("chatgpt")
wk.register({
  a = {
    name = "ChatGPT",
    i = {
      chatgpt.edit_with_instructions,
      "Edit with instructions",
    },
  },
}, {
  prefix = "<leader>",
  mode = "v",
})

wk.register({
  a = {
    name = "ChatGPT",
    i = {
      chatgpt.openChat,
      "Chat with [AI]",
    },
  },
}, {
  prefix = "<leader>",
  mode = "n",
})

wk.register({
  a = {
    name = "ChatGPT",
    p = {
      function()
        chatgpt.selectAwesomePrompt()
      end,
      "Chat with [A]I [P]rompt",
    },
  },
}, {
  prefix = "<leader>",
  mode = "n",
})
-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require('cmp')
local luasnip = require('luasnip')
vim.keymap.set('n', '<space>ss', "<cmd>source ~/.config/nvim/lua/after/luasnip.lua<CR>", { desc = '[S]ource [S]nippets' })
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
local lspkind = require('lspkind')
cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      -- maxwidth = 50,
      -- ellipsis_char = '...',
    })
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
    border = 'rounded',
    scrollbar = true,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<CR>'] = cmp.mapping.confirm({
      -- behavior = cmp.ConfirmBehavior.Replace,
      -- select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable() then
        luasnip.jump(1)
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})


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

vim.keymap.set('n', "<leader>iwp", [[viw"_dP]], { desc = "paste in word" })
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
--local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

-- local autocmd = vim.api.nvim_create_autocmd
-- autocmd("BufWinEnter", {
--     group = ThePrimeagen_Fugitive,
--     pattern = "*",
--     callback = function()
--         print("help", vim.bo.ft)
--         if vim.bo.ft ~= "fugitive" then
--             return
--         end
--
--         local bufnr = vim.api.nvim_get_current_buf()
--         local opts = {buffer = bufnr, remap = false}
--         print("great success", vim.bo.ft, bufnr, vim.inspect(opts))
--         vim.keymap.set("n", "<leader>p", function()
--             vim.cmd [[ Git push ]]
--         end, opts)
--
--         -- rebase always
--         vim.keymap.set("n", "<leader>P", function()
--             vim.cmd [[ Git pull --rebase ]]
--         end, opts)
--
--         -- NOTE: It allows me to easily set the branch i am pushing and any tracking
--         -- needed if i did not set the branch up correctly
--         vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
--     end,
-- })


--TODO:
--ok heres the deal, we always qa....q,
--What about <C-a>....<C-a>🤯🤯🤯
-- because that's your tmux leader dummy
--then we go <A-a> to run
-- ok how about;
vim.keymap.set('n', '<C-1>', 'qa', { noremap = true, desc = 'Record macro to register a' })
vim.keymap.set('n', '<A-1>', '@a<cr>', { noremap = true, desc = 'Run macro reg a' })

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
