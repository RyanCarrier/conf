return {
  "ThePrimeagen/vim-be-good",
  "nvim-tree/nvim-web-devicons", -- optional dependency
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- multi line ctrl-n
  'mg979/vim-visual-multi',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  'nvim-tree/nvim-tree.lua',
  'stevearc/dressing.nvim',
  {
    --regex explanation
    'tomiis4/hypersonic.nvim',
    config = function()
      require('hypersonic').setup({})
    end
  },
  {
    'stevearc/overseer.nvim',
    -- This isn't working with my build runner task at the moment, but I don't care too much
    -- TODO: this
    config = function()
      local o = require('overseer')
      o.setup()
      vim.keymap.set('n', '<leader>ta', o.run_template, { desc = '[Ta]sks' })
    end
  },
  'akinsho/bufferline.nvim',
  {
    'tzachar/highlight-undo.nvim',
    config = function()
      require('highlight-undo').setup({
        keymaps = {
          { 'n', 'u',     'undo', {} },
          { 'n', '<C-r>', 'redo', {} },
        },
        duration = 300,
        hlgroup = 'HighlightUndo'
      })
    end
  },

  'mrjones2014/smart-splits.nvim',

  --todo: it fucked up my - for oil
  -- {
  --   'm4xshen/hardtime.nvim',
  --   event = "VeryLazy",
  --   config = function()
  --     require("hardtime").setup({
  --     })
  --   end
  -- },
  { 'folke/noice.nvim', enabled = false },

  --undo list
  'mbbill/undotree',
  'machakann/vim-sandwich',
  'rcarriga/nvim-notify',
  -- zenmode
  'folke/zen-mode.nvim',
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'b0o/incline.nvim',
    config = function()
      require('incline').setup()
    end
  },

  --highlight hovered
  "RRethy/vim-illuminate",
  --highlight when cursor jumps
  "danilamihailov/beacon.nvim",
  -- make buffer collapse
  "eandrju/cellular-automaton.nvim",
  -- dim other windows
  "levouh/tint.nvim",
  {
    --scrollbar ... lol
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()
    end
  },
  {
    -- shows up top what you in/where u is
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
    config = function()
      -- triggers CursorHold event faster
      vim.opt.updatetime = 200

      require("barbecue").setup({
        create_autocmd = false, -- prevent barbecue from updating itself automatically
        them = 'tokyonight',
      })

      vim.api.nvim_create_autocmd({
        "WinResized", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end
  },
  {
    'simrat39/rust-tools.nvim',
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end
        }
      })
    end
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'onsails/lspkind-nvim',
      --     'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-path',
      --     'hrsh7th/cmp-buffer',
      'hrsh7th/vim-vsnip',

      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },
  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {}
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        -- icons_enabled = false,
        theme = 'tokyonight-night', -- -night', --'onedark',
        -- theme = 'material', --'tokyonight', -- -night', --'onedark',
        --component_separators = '|',
        --section_separators = '',

      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        sections = {
          lualine_x = { "overseer" },
        }
      })
    end
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    opts = {
      -- config = function()
      --   require('Comment').setup({
      --     toggler = {
      --     this didn't work lol
      --       line = { "<leader>/", "gcc" },
      --     }
      --   })
      -- end
    }
  },
  {
    'nvim-treesitter/playground',
    config = function()
      vim.keymap.set('n', '<leader>tp', ':TSPlaygroundToggle<CR>',
        { desc = "[T]reesitter [P]layground", noremap = true, silent = true })
    end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end
  }
}
