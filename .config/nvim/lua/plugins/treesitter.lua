return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- BufReadPost/BufNewFile で遅延ロード
        -- → lazy.nvimがrtp追加を完了した後にrequireされるためエラーが出ない
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.config").setup({
                highlight    = { enable = true },
                indent       = { enable = true },
                auto_install = true,
            })
        end,
    },
}
