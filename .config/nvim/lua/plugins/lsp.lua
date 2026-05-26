return {
    -- LSPサーバーのインストール管理 (:Mason で UI表示、:MasonInstall <server> でインストール)
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({ ui = { border = "rounded" } })
        end,
    },

    -- masonとlspconfigの橋渡し (インストール済みサーバーを自動設定)
    -- mason-lspconfig v2: setup_handlers廃止 → setup()内のhandlersに統合
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = require("blink.cmp").get_lsp_capabilities(),
                        })
                    end,
                },
            })
        end,
    },

    -- LSP本体設定
    {
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp" },
        config = function()
            -- LspAttach時にキーマップをバッファローカルで設定
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local buf = args.buf
                    local function bmap(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true })
                    end

                    bmap("n", "gd",        vim.lsp.buf.definition)
                    bmap("n", "gy",        vim.lsp.buf.type_definition)
                    bmap("n", "gi",        vim.lsp.buf.implementation)
                    bmap("n", "gr",        vim.lsp.buf.references)
                    bmap("n", "==",        function() vim.lsp.buf.format({ async = true }) end)
                    bmap("n", "ghh",       vim.lsp.buf.hover)
                    bmap("n", "<A-CR>",    vim.lsp.buf.code_action)
                    bmap("n", "gan",       vim.diagnostic.goto_next)
                    bmap("n", "gab",       vim.diagnostic.goto_prev)
                    bmap("n", "<Space>r",  vim.lsp.buf.rename)
                end,
            })

            -- diagnosticのアイコン設定
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN]  = "",
                        [vim.diagnostic.severity.INFO]  = "",
                        [vim.diagnostic.severity.HINT]  = "",
                    },
                },
                virtual_text = true,
                float = { border = "rounded" },
            })
        end,
    },

    -- 補完エンジン (coc.nvimの補完UI相当)
    -- version="*" でプリビルドバイナリを使用 (Rustコンパイル不要)
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            "saghen/blink.lib",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        opts = {
            keymap = {
                preset = "none",
                ["<C-j>"]     = { "select_next", "fallback" },
                ["<C-k>"]     = { "select_prev", "fallback" },
                ["<CR>"]      = { "accept", "fallback" },
                ["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
                ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
            },
            appearance = { nerd_font_variant = "mono" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            snippets = { preset = "luasnip" },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 300 },
                menu = { border = "rounded" },
            },
        },
    },

    -- スニペットエンジン
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}
