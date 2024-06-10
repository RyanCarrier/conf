-- autoformat.lua
--
-- Use your language server to automatically format your code on save.
-- Adds additional commands as well to manage the behavior

return {
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
    -- Switch for controlling whether you want autoformatting.
    --  Use :FormatToggle to toggle autoformatting on or off
    local format_is_enabled = true
    vim.api.nvim_create_user_command('FormatToggle', function()
      format_is_enabled = not format_is_enabled
      print('Setting autoformatting to: ' .. tostring(format_is_enabled))
    end, {})

    -- Create an augroup that is used for managing our formatting autocmds.
    --      We need one augroup per client to make sure that multiple clients
    --      can attach to the same buffer without interfering with each other.
    local _augroups = {}
    local get_augroup = function(client)
      if not _augroups[client.id] then
        local group_name = 'lsp-format-' .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
      end
      return _augroups[client.id]
    end

    -- Whenever an LSP attaches to a buffer, we will run this function.
    --
    -- See `:help LspAttach` for more information about this autocmd event.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach-format', { clear = true }),
      -- This is where we attach the autoformatting for reasonable clients
      callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf
        -- if client.name == 'dartls' then
        --   return
        -- end
        if client == nil then
          vim.notify('client is nil')
          return
        end
        if client.name == "eslint" then
          client.server_capabilities.documentFormattingProvider = true
        end
        -- Only attach to clients that support document formatting
        if not client.server_capabilities.documentFormattingProvider then return end
        --eslint instead yo
        if client.name == 'tsserver' then return end
        -- Create an autocmd that will run *before* we save the buffer.
        --  Run the formatting command for the LSP that has just attached.
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = get_augroup(client),
          buffer = bufnr,
          callback = function()
            if not format_is_enabled then
              vim.notify(client.id .. 'FORMAT NOT ENABLED ')
              return
            end
            -- this does not work so it must be when saving is the issue
            -- if client.name == 'dartls' then
            --   vim.notify("not formatting dart")
            --   return
            -- end

            vim.lsp.buf.format({
              -- async = true,
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            })
            -- fix that dumbass bug when sometimes after format call diag will peace out
            -- if client.name == 'dartls' then vim.diagnostic.enable(bufnr) end
            --this didn't work either >.>
            if require('modules.debug').enabled then vim.notify(client.name .. ' FORMATED') end
          end,
        })
      end,
    })
  end,
}
