return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', config = true },
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
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
