return {
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        keys = {
            { "<S-h>",   "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
            { "<S-l>",   "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
            { "<Space><S-h>", "<cmd>BufferLineMovePrev<CR>",  desc = "Move buffer left" },
            { "<Space><S-l>", "<cmd>BufferLineMoveNext<CR>",  desc = "Move buffer right" },
        },
        opts = {
            options = {
                separator_style          = "thin",
                show_close_icon          = false,
                show_buffer_close_icons  = false,  -- バッファごとの×ボタン無効
                diagnostics              = "nvim_lsp",
                -- nvim-treeを開いているときにオフセットを設定
                offsets = {
                    {
                        filetype  = "NvimTree",
                        text      = "File Explorer",
                        separator = true,
                    },
                },
            },
        },
    },
}
