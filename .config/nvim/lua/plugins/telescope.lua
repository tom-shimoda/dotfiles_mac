return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        keys = {
            { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
            { "<C-g>", "<cmd>Telescope live_grep<CR>",  desc = "Live grep" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    border = true,
                    layout_strategy = "horizontal",
                    layout_config = { preview_width = 0.5 },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                    -- 旧fzf.vim Rgコマンドと同等: 隠しディレクトリ検索・大小文字無視
                    live_grep = {
                        additional_args = { "--hidden", "--ignore-case" },
                    },
                },
            })
            telescope.load_extension("fzf")
        end,
    },
}
