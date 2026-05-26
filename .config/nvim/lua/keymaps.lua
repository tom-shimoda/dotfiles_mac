local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 誤爆防止
map("n", "<Space>", "<Nop>", opts)
map("n", "<C-q>", "<Nop>", opts)

-- vimrc再読み込み
map("n", "<Space>g", ":source ~/.config/nvim/init.lua<CR>", opts)

-- 3行移動
map({ "n", "v" }, "<S-j>", "jjj", opts)
map({ "n", "v" }, "<S-k>", "jjj", opts)
map({ "n", "v" }, "<C-j>", "kkk", opts)
map({ "n", "v" }, "<C-k>", "kkk", opts)

-- 行頭/行末
map({ "n", "v" }, "<Space>h", "^", opts)
map({ "n", "v" }, "<Space>l", "$", opts)

-- ファイル末尾/前後履歴
map("n", "<Space><CR>", "G", opts)
map("n", "<Space>b", "<C-o>zz", opts)
map("n", "<Space>n", "<C-i>zz", opts)

-- 行結合
map({ "n", "v" }, "<Space>j", "gJ", opts)

-- バッファ操作 (<S-h>/<S-l>の移動はbufferline.luaで定義)
map("n", "<leader>x", ":bp<CR>:bd #<CR>", opts)

-- ハイライト切替
map("n", "<F1>", ":noh<CR>", opts)

-- ウィンドウ移動
map("n", "<C-h>", "<C-w>W", opts)
map("n", "<C-l>", "<C-w>w", opts)


-- Y = yy (v0.6以降の変更を戻す)
map("n", "Y", "yy", opts)
map("n", "<S-y>", "yy", opts)

-- クリップボードコピー
map({ "n", "v" }, "<C-c>", '"*yy', opts)

-- 削除系はレジスタ0へ (yankレジスタを汚さない)
map("v", "c", '"0c', opts)
map("v", "x", '"0x', opts)
map("v", "d", '"0d', opts)
map("v", "D", '"0D', opts)
map("n", "di(", '"0di(', opts)
map("n", "di[", '"0di[', opts)
map("n", "di{", '"0di{', opts)
map("n", "di'", '"0di\'', opts)
map("n", 'di"', '"0di"', opts)
map("n", "D", '"0D', opts)
map("n", "dd", '"0dd', opts)

-- カーソル下シンボル操作
map("n", "<Space>y", "wbvey", opts)
map("n", "<Space>c", "wbvec", opts)
map("n", "<Space>p", 'wbve"0p', opts)

-- ペーストはレジスタ0から (範囲選択ペースト時のレジスタ汚染を防ぐ)
map({ "n", "v" }, "p", '"0p', opts)
map({ "n", "v" }, "P", '"0P', opts)

-- 終了 (nvim-tree/dap-uiを閉じてから終了)
map("n", "ZZ", "<cmd>lua Exit()<CR>", opts)

-- .h/.cpp トグル
map("n", "<Space>t", "<cmd>lua ToggleHeaderSource()<CR>", opts)

-- グローバル関数
function _G.Exit()
    -- package.loaded で確認することでlazy loadをトリガーしない
    local tree = package.loaded["nvim-tree.api"]
    if tree then pcall(function() tree.tree.close() end) end
    local dapui = package.loaded["dapui"]
    if dapui then pcall(function() dapui.close() end) end
    vim.cmd("q!")
end

function _G.ToggleHeaderSource()
    local ext = vim.fn.expand("%:e")
    local base = vim.fn.expand("%:r")
    if ext == "cpp" then
        vim.cmd("find " .. base .. ".h")
    elseif ext == "h" then
        vim.cmd("find " .. base .. ".cpp")
    end
end
