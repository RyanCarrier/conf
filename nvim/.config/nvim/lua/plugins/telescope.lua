-- Fuzzy Finder (files, lsp, etc)
return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
      telescope.setup({
        pickers = {
          live_grep = {
            additional_args = function(opts)
              -- return { "--hidden", "--no-ignore-vcs", "--glob", "!.git" }
              return { "--hidden", "--glob", "!.git" }
            end
          },
          colorscheme = {
            enable_preview = true
          }
        },
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
    end,
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
}
