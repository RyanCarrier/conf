return {
  {
    -- LSP client configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- portable package manager for LSP servers, linters, formatters
      { 'mason-org/mason.nvim', config = true },
      -- bridges mason and lspconfig (auto-enable installed servers)
      'mason-org/mason-lspconfig.nvim',
      -- LSP progress spinner in bottom right
      { 'j-hui/fidget.nvim', opts = {} },
    },
  },
  {
    -- Lua LSP setup for neovim config development
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- auto-install formatters, linters, and other tools via mason
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
          "rust-analyzer",
          "lua-language-server",
          "json-lsp",
          "yaml-language-server",
          "dockerfile-language-server",
          "actionlint",
        },
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
