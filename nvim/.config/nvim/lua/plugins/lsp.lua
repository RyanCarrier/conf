-- autoformat.lua
--
-- Use your language server to automatically format your code on save.
-- Adds additional commands as well to manage the behavior

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
    config = function()
      -- idk try this TODO: havn't actually tried this yet
      -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      --   vim.lsp.diagnostic.on_publish_diagnostics, {
      --     -- delay update diagnostics
      --     update_in_insert = true,
      --   }
      -- )
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettierd",
          "black",
          "shfmt",
          "shellcheck",
          "eslint_d",
          "typescript-language-server",
          "rust-analyzer",
          "lua-language-server",
          "json-lsp",
          "yaml-language-server",
          "dockerfile-language-server",
          "actionlint",
        },
        -- auto_update = true,
        run_on_start = true,
        integrations = {
          ['mason-lspconfig'] = true,
          ['mason-null-lspconfig'] = true,
          ['mason-nvim-dap'] = true,
        },
      })
    end
  }
}
