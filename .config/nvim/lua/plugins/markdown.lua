-- markview.nvim: Markdownをリアルタイムでレンダリングするプレビュープラグイン
--
-- 【基本操作】
--   :Markview          レンダリングのON/OFFをトグル
--   :Markview enable   レンダリングを有効化
--   :Markview disable  レンダリングを無効化
--   :Markview toggle   同上（トグル）
--
-- 【Split プレビュー】
--   :Markview splitToggle   分割ウィンドウプレビューのON/OFFをトグル
--   :Markview splitEnable   分割プレビューを開く
--   :Markview splitDisable  分割プレビューを閉じる
--
-- 【動作】
--   Markdownファイルを開くと自動でレンダリングが有効になる
--   挿入モード中はソーステキストに戻り、ノーマルモードで再レンダリングされる
return {
    {
        "OXY2DEV/markview.nvim",
        ft = { "markdown", "rmd", "quarto" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    },
}
