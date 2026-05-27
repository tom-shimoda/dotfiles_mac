return {
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_transparent_background = 1
            vim.opt.background = "dark"
            vim.cmd("colorscheme gruvbox-material")
        local function nvimtree_focused()
            vim.api.nvim_set_hl(0, "NvimTreeNormal",      { bg = "#404040" })
            vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "#404040" })
        end
        local function nvimtree_unfocused()
            vim.api.nvim_set_hl(0, "NvimTreeNormal",      { bg = "NONE", ctermbg = "NONE" })
            vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
        end
        nvimtree_focused()
        vim.api.nvim_create_autocmd("ColorScheme",  { callback = nvimtree_focused })
        vim.api.nvim_create_autocmd("FocusGained",  { callback = nvimtree_focused })
        vim.api.nvim_create_autocmd("FocusLost",    { callback = nvimtree_unfocused })
        end,
    },
}
