-- Fuzzy Finder (files, lsp, etc)
return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- config = function()
    --   require('telescope').setup({
    --     defaults = {
    --       vimgrep_arguments = {
    --         'rg',
    --         '--color=never',
    --         '--no-heading',
    --         '--with-filename',
    --         '--line-number',
    --         '--column',
    --         '--smart-case',
    --         '--hidden',
    --         '-g',
    --         '!.git',
    --       }
    --     }
    --   })
    -- end,
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
