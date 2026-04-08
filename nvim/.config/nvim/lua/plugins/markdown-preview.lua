return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- build = function() vim.fn["mkdp#util#install"]() end,
    -- build = "bun install",
    build = ":call mkdp#util#install()",
    init = function()
        vim.g.mkdp_auto_close = 0
    end,
    -- "selimacerbas/markdown-preview.nvim",
    -- dependencies = { "selimacerbas/live-server.nvim" },
    -- config = function()
    --   require("markdown_preview").setup({
    --     -- all optional; sane defaults shown
    --     port = 8421,
    --     open_browser = true,
    --     debounce_ms = 300,
    --   })
    -- end,
}
