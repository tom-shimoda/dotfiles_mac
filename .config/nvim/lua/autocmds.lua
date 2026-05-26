local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 改行時の自動コメントアウトを無効化
autocmd("BufEnter", {
    group = augroup("no_auto_comment", { clear = true }),
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- tmuxのpaneフォーカスハイライトを反映させるため背景を透過
autocmd("ColorScheme", {
    group = augroup("transparent_bg", { clear = true }),
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
    end,
})

-- TODO/NOTE等のキーワードをハイライト
-- Syntaxイベントはtreesitter環境で頻発するため除外
-- matchaddの重複追加を防ぐためgetmatchesで確認してから追加
autocmd({ "WinEnter", "BufRead", "BufNew" }, {
    group = augroup("highlight_keywords", { clear = true }),
    callback = function()
        local pattern = [[\(TODO\|NOTE\|INFO\|XXX\|TEMP\):]]
        for _, m in ipairs(vim.fn.getmatches()) do
            if m.pattern == pattern then return end
        end
        vim.fn.matchadd("Todo", pattern)
        vim.api.nvim_set_hl(0, "Todo", { bg = "Red", fg = "White" })
    end,
})
