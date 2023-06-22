return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
    },
    config = function()
      require("tokyonight").setup({
        -- use the night style
        style = "night",
        -- disable italic for functions
        -- Change the "hint" color to the "orange" color, and make the "error" color bright red
        on_colors = function(colors)
          colors.bg = colors.black
          colors.border = colors.purple
          colors.border_highlight = colors.purple
          -- colors.bg_search = colors.orange

          --colors.bg_float = colors.red
          --side bar is the section down bottom which 'which' plugin uses
          --         colors.bg_sidebar = colors.green
          -- colors.bg_popup = colors.teal
        end,


        on_highlights = function(hl, c)
          hl.ColorColumn = { bg = "#202122" }
          c.bg_float = c.red
        end,
        -- might be cool to test some of these from folkes dot
        -- on_highlights = function(hl, c)
        --         hl.CursorLineNr = { fg = c.orange, bold = true }
        --         hl.LineNr = { fg = c.orange, bold = true }
        --         hl.LineNrAbove = { fg = c.fg_gutter }
        --         hl.LineNrBelow = { fg = c.fg_gutter }
        --         local prompt = "#2d3149"
        --         hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
        --         hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
        --         hl.TelescopePromptNormal = { bg = prompt }
        --         hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
        --         hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
        --         hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
        --         hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        --       end,
        styles = {
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },

        --         hl.ctermbg = {
        --           fg = colors.green,
        --           bg = colors.cyan,
        --      }
        -- end

      })
      vim.cmd.colorscheme('tokyonight-night')
    end
  },
  { "nyoom-engineering/oxocarbon.nvim", name = 'oxocarbon' },
  { 'rafamadriz/neon',                  name = 'neon' },
  { "catppuccin/nvim",                  name = "catppuccin" },
  {
    'olimorris/onedarkpro.nvim',
    -- vim.cmd("colorscheme onedark")
    -- onedark, onelight, onedark_vivid, onedark_dark
    config = function()
      require('onedarkpro').setup({
        highlights = {

        }

      })
      local options = { "onedark", "onelight", "onedark_vivid", "onedark_dark" }
      -- vim.cmd.colorscheme(options[4])
    end
  },
  {
    'marko-cerovac/material.nvim',
    -- vim.cmd("colorscheme material")
    -- vim.g.material_style = "deep ocean"
    -- darker, lighter, oceanic, palenight, deep ocean
    config = function()
      local options = { "darker", "lighter", "oceanic", "palenight", "deep ocean" }
      -- vim.g.material_style = options[5]
      -- vim.cmd.colorscheme('material')
    end
  },

}
