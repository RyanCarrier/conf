return {
  {
    -- fancy notification popups
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
  -- vim motion practice game
  "ThePrimeagen/vim-be-good",
  -- file type icons
  "nvim-tree/nvim-web-devicons",
  -- git wrapper (:Git, :Gdiff, etc.)
  'tpope/vim-fugitive',
  -- GitHub integration for fugitive (:GBrowse)
  'tpope/vim-rhubarb',

  -- multi line ctrl-n
  -- 'mg979/vim-visual-multi',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- bottom bar stuff make fancy
  -- 'gelguy/wilder.nvim', -- this might be cool but need to set keymaps etc(does cmdline highlithgting and auto complete)
  -- improved vim.ui.select and vim.ui.input
  'stevearc/dressing.nvim',
  {
    -- Cargo.toml dependency management (versions, features, docs)
    'saecki/crates.nvim',
    tag = 'stable',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },
  {
    -- interactive regex explanation
    'tomiis4/hypersonic.nvim',
    config = function()
      require('hypersonic').setup({})
    end
  },
  {
    -- task runner and job management
    'stevearc/overseer.nvim',
    config = function()
      require('overseer').setup()
    end
  },

  -- i dont' think i use this cause i don't use tabs tbh
  -- 'akinsho/bufferline.nvim',
  {
    -- highlights changed text on undo/redo
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
    -- navigate and resize splits seamlessly between nvim and tmux
    'mrjones2014/smart-splits.nvim',
    config = function()
      require('smart-splits').setup({
        default_amount = 5,
      })
    end,
  },

  {
    -- replaces cmdline, messages, and popupmenu with fancy UI
    'folke/noice.nvim',
    opts = {},
    -- enabled = false,
  },

  -- visual undo history tree
  'mbbill/undotree',
  -- surround text objects (sa/sd/sr)
  'machakann/vim-sandwich',
  -- zenmode, never used it tho
  -- 'folke/zen-mode.nvim',
  {
    -- file browser as editable buffer
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

  -- highlight other occurrences of word under cursor
  "RRethy/vim-illuminate",
  -- flash beacon on cursor jumps
  "danilamihailov/beacon.nvim",
  -- fun cell automaton animation on buffer (:CellularAutomaton)
  "eandrju/cellular-automaton.nvim",
  -- dim other windows
  "levouh/tint.nvim",
  {
    -- scrollbar with search/diagnostics markers
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()
    end
  },
  {
    -- winbar breadcrumbs showing current code location
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
  -- enhanced Rust tooling (LSP, DAP, crate graph)
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
    -- keybind for built-in :InspectTree (treesitter AST viewer)
    'nvim-treesitter/nvim-treesitter',
    keys = {
      { '<leader>tp', '<cmd>InspectTree<CR>', desc = '[T]reesitter [P]layground (InspectTree)' },
    },
  },
  {
    -- visual indent guide blocks
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
  -- tab to jump out of brackets/quotes
  'abecodes/tabout.nvim',
  -- {
  --   -- testing this idk if i will keep it
  --   'folke/flash.nvim',
  --   event = "VeryLazy",
  -- },
  {
    -- preview code actions in a picker before applying
    "aznhe21/actions-preview.nvim",
  },
  -- Firestore security rules syntax highlighting
  "delphinus/vim-firestore",
  {
    -- render markdown inline in buffer (headings, lists, etc.)
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  {
    -- unix shell commands (:Delete, :Rename, :Chmod, :Move, etc.)
    "tpope/vim-eunuch",
  },
  {
    -- toggle checkboxes in markdown files
    "bngarren/checkmate.nvim",
    ft = "markdown",
    opts = {},
  }
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   dependencies = { "kevinhwang91/promise-async",
  --     {
  --       "luukvbaal/statuscol.nvim",
  --       config = function()
  --         local builtin = require("statuscol.builtin")
  --         require("statuscol").setup({
  --           relculright = true,
  --           segments = {
  --             { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
  --             { text = { "%s" },                  click = "v:lua.ScSa" },
  --             { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
  --           },
  --         })
  --       end,
  --     },
  --   },
  --   config = function()
  --     require('ufo').setup({
  --       provider_selector = function(bufnr, filetype, buftype)
  --         return { 'treesitter', 'indent' }
  --       end,
  --       -- preview = {
  --       --   win_config = {
  --       --     winblend = 0,
  --       --     winhighlight = "Normal:Normal",
  --       --   },
  --       -- },
  --     })
  --   end
  -- },

}
