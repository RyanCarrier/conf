return {
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
      vim.api.nvim_create_autocmd(
        "RecordingEnter", {
          callback = function(ctx)
            vim.opt.cmdheight = 1
            local msg = string.format("Key:  %s\nFile: %s", vim.fn.reg_recording(), ctx.file)
            vim.notify(msg, vim.log.levels.INFO, {
              title = "Macro Recording"
            })
          end
        })

      vim.api.nvim_create_autocmd(
        "RecordingLeave", {
          callback = function()
            vim.opt.cmdheight = 0
          end
        })
    end
  },
  "luckasRanarison/tree-sitter-hypr",
  "ThePrimeagen/vim-be-good",
  "nvim-tree/nvim-web-devicons",
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- multi line ctrl-n
  -- 'mg979/vim-visual-multi',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- bottom bar stuff make fancy
  -- 'gelguy/wilder.nvim', -- this might be cool but need to set keymaps etc(does cmdline highlithgting and auto complete)
  'stevearc/dressing.nvim', --nice selector ui
  {
    'saecki/crates.nvim',   -- it is nice for rust crates stuff, TODO: more here, cause you can  prompt for things like features to select from
    -- but also can rustaceanvim do it?
    -- https://github.com/Saecki/crates.nvim/wiki/Documentation-v0.4.0
    tag = 'stable',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },
  {
    --regex explanation
    'tomiis4/hypersonic.nvim',
    config = function()
      require('hypersonic').setup({})
    end
  },
  {
    -- tasks
    'stevearc/overseer.nvim',
    config = function()
      require('overseer').setup()
    end
  },

  -- i dont' think i use this cause i don't use tabs tbh
  -- 'akinsho/bufferline.nvim',
  {
    --highlights when you undo, is nice
    'tzachar/highlight-undo.nvim',
    config = function()
      require('highlight-undo').setup({
        -- keymaps = {
        --   { 'n', 'u',     'undo', {} },
        --   { 'n', '<C-r>', 'redo', {} },
        -- },
        -- duration = 300,
        -- hlgroup = 'HighlightUndo'
      })
    end
  },
  {
    -- this bad boy is slow but also i like it lets me jump out of nvim to tmux too
    'mrjones2014/smart-splits.nvim',
    config = function()
      require('smart-splits').setup({
        default_amount = 5,
      })
    end,
  },

  {
    -- just fancy things
    'folke/noice.nvim',
    opts = {},
    -- enabled = false,
  },

  --undo list
  'mbbill/undotree',
  -- surround stuff
  'machakann/vim-sandwich',
  -- zenmode, never used it tho
  -- 'folke/zen-mode.nvim',
  {
    -- bless file browser
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- {
  --   -- floating status lines, this should be riced slightly but whatever
  --   'b0o/incline.nvim',
  --   config = function()
  --     require('incline').setup()
  --   end
  -- },

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
  'mrcjkb/rustaceanvim',
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        -- icons_enabled = false,
        theme = 'tokyonight-night', -- -night', --'onedark',
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
    -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    opts = {},
  },
  {
    'nvim-treesitter/playground',
    config = function()
      vim.keymap.set('n', '<leader>tp', ':TSPlaygroundToggle<CR>',
        { desc = "[T]reesitter [P]layground", noremap = true, silent = true })
    end
  },
  {
    "HampusHauffman/block.nvim",
    config = function()
      require("block").setup({
        percent = 0.9,
      })
    end
  },
  {
    -- show marks on the left
    'chentoast/marks.nvim',
    config = function()
      require("marks").setup({
        default_mappings = true,
      })
    end
  },
  -- {
  -- maybe later when i care
  -- pre sure this is for like => to (){}
  --   'Wansmer/treesj',
  --   -- TODO: double check this is enough to set the default keys, might have to change in the config too
  --   keys = { '<space>nm', '<space>nj', '<space>ns' },
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     require('treesj').setup({ --[[ your config ]] })
  --   end,
  -- },
  {
    -- jumps to line while still typing (like :270)
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup({})
    end
  },
  -- shoudl be able to just tab to get out of things that aren't strings
  'abecodes/tabout.nvim',
  -- {
  --   -- testing this idk if i will keep it
  --   'folke/flash.nvim',
  --   event = "VeryLazy",
  -- },
  {
    "aznhe21/actions-preview.nvim",
  },
  "delphinus/vim-firestore",
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  { "tpope/vim-eunuch",
    -- :Delete
    -- don't remember why i just added but look it up
  }
}
