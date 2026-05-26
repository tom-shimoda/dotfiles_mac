return {
    -- カッコの自動補完 (auto-pairs → nvim-autopairs)
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts  = {},
    },

    -- コメントトグル
    -- Ctrl+/ でトグル (Vimでは<C-_>)
    {
        "tpope/vim-commentary",
        keys = {
            { "<C-_>", ":Commentary<CR>",  desc = "Toggle comment" },
            { "<C-_>", ":Commentary<CR>",  mode = "v", desc = "Toggle comment" },
        },
    },

    -- モーション (vim-easymotion → flash.nvim)
    -- ,, で文字検索ジャンプ (easymotion の <leader><leader>s 相当)
    {
        "folke/flash.nvim",
        keys = {
            { ",,", function() require("flash").jump() end, desc = "Flash jump" },
        },
    },

    -- カッコのレインボーカラー (treesitter連携版)
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("rainbow-delimiters.setup").setup({
                strategy = { [""] = require("rainbow-delimiters").strategy["global"] },
                query    = { [""] = "rainbow-delimiters" },
            })
        end,
    },

    -- テーブル編集 (そのまま継続)
    {
        "dhruvasagar/vim-table-mode",
        cmd = { "TableModeEnable", "TableModeToggle" },
        init = function()
            vim.g.table_mode_corner        = "+"
            vim.g.table_mode_corner_corner = "|"
            vim.g.table_mode_header_fillchar = "="
        end,
    },

    -- スムーズスクロール
    {
        "karb94/neoscroll.nvim",
        opts = { duration_multiplier = 0.4 },
    },
}
