return {
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end
  },

  "luckasRanarison/tree-sitter-hypr",

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
      vim.keymap.set('n', '<leader>taa', o.run_template, { desc = '[Ta]sks' })
      vim.keymap.set('n', '<leader>tao', o.toggle, { desc = '[Ta]sks [O]pen' })
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

  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      require('smart-splits').setup({
        default_amount = 5,
      })
    end,
  },

  --todo: it fucked up my - for oil
  -- {
  --   'm4xshen/hardtime.nvim',
  --   event = "VeryLazy",
  --   config = function()
  --     require("hardtime").setup({
  --       restriction_mode = "hint",
  --       disabled_keys = {
  --         ["-"] = {},
  --       },
  --       disabled_filetypes = { "oil" },
  --     })
  --   end
  -- },
  { 'folke/noice.nvim', enabled = false },

  --undo list
  'mbbill/undotree',
  {
    'machakann/vim-sandwich',
  },
  -- zenmode
  'folke/zen-mode.nvim',
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    -- floating status lines, this should be riced slightly but whatever
    'b0o/incline.nvim',
    config = function()
      require('incline').setup()
    end
  },
  -- move language support
  "rvmelkonian/move.vim",

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
      require("rust-tools").setup({})
    end
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
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end
  }
}
