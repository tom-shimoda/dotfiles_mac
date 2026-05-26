return {
    -- ステータスライン + タブライン (airline → lualine)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "gruvbox-material",
                    globalstatus = true,
                    -- powerline記号に依存しないシンプルなセパレータ
                    -- section_separators   = { left = "", right = "" },
                    -- component_separators = { left = "│", right = "│" },
                    -- 更新頻度を下げてカーソル移動の負荷を軽減
                    refresh = {
                        statusline = 1000,
                        tabline    = 1000,
                    },
                },
                -- tablineはbufferline.nvimが担当
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", { "filetype", icons_enabled = true } },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- ファイルツリー (既存のnvim-treeをそのまま継続)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<F2>", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file tree" },
        },
        config = function()
            vim.g.loaded_netrw       = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup()

            -- 最後のバッファがnvim-treeのみになったら自動で閉じる
            vim.api.nvim_create_autocmd("BufEnter", {
                nested = true,
                callback = function()
                    if #vim.api.nvim_list_wins() == 1 then
                        local utils = package.loaded["nvim-tree.utils"]
                        if utils and utils.is_nvim_tree_buf() then
                            vim.cmd("quit")
                        end
                    end
                end,
            })
        end,
    },

    -- git差分表示 (vim-gitgutter → gitsigns)
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            { "ghn", function() require("gitsigns").next_hunk() require("gitsigns").preview_hunk() end, desc = "Next hunk & preview" },
            { "ghb", function() require("gitsigns").prev_hunk() require("gitsigns").preview_hunk() end, desc = "Prev hunk & preview" },
            { "ghs", "<cmd>Gitsigns stage_hunk<CR>",   desc = "Stage hunk" },
            { "ghu", "<cmd>Gitsigns reset_hunk<CR>",   desc = "Undo hunk" },
            { "ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
        },
        opts = {},
    },

    -- アイコン
    { "nvim-tree/nvim-web-devicons", lazy = true },
}
