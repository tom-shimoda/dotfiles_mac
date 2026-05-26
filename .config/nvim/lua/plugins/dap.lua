return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {},
                automatic_installation = true,
                handlers = {},
            })
        end,
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
        },
        keys = {
            { "<F4>",       "<cmd>lua require'dapui'.toggle()<CR>",                                                desc = "DAP UI toggle" },
            { "<F5>",       "<cmd>lua require'dap'.continue()<CR>",                                               desc = "DAP continue" },
            { "<F6>",       "<cmd>lua require'dap'.terminate()<CR>",                                              desc = "DAP terminate" },
            { "<F9>",       "<cmd>lua require'dap'.toggle_breakpoint()<CR>",                                      desc = "DAP toggle breakpoint" },
            { "<F10>",      "<cmd>lua require'dap'.step_over()<CR>",                                              desc = "DAP step over" },
            { "<F11>",      "<cmd>lua require'dap'.step_into()<CR>",                                              desc = "DAP step into" },
            { "<F12>",      "<cmd>lua require'dap'.step_out()<CR>",                                               desc = "DAP step out" },
            { "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Condition: '))<CR>",              desc = "DAP conditional breakpoint" },
            { "<leader>l",  "<cmd>lua require'dap'.set_breakpoint(nil,nil,vim.fn.input('Log message: '))<CR>",   desc = "DAP log point" },
            { "<leader>d",  "<cmd>lua require'dapui'.toggle()<CR>",                                              desc = "DAP UI toggle" },
            { "<leader>e",  "<cmd>lua require'dapui'.eval()<CR>",                                                desc = "DAP eval" },
        },
        config = function()
            local dap    = require("dap")
            local dapui  = require("dapui")

            -- ブレークポイントアイコン
            vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

            -- デバッグ開始時にUIを自動表示
            dap.listeners.before["event_initialized"]["custom"] = function()
                dapui.open()
            end

            -- dap-ui
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open   = "o",
                    remove = "d",
                    edit   = "e",
                    repl   = "r",
                    toggle = "t",
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            "breakpoints",
                            "stacks",
                            "watches",
                        },
                        size     = 40,
                        position = "right",
                    },
                    {
                        elements = { "repl" },
                        size     = 0.25,
                        position = "bottom",
                    },
                },
                controls = {
                    enabled = true,
                    element = "repl",
                    icons = {
                        pause     = "",
                        play      = "",
                        step_into = "",
                        step_over = "",
                        step_out  = "",
                        step_back = "",
                        run_last  = "↻",
                        terminate = "□",
                    },
                },
                floating = {
                    border   = "single",
                    mappings = { close = { "q", "<Esc>" } },
                },
            })

            -- dap-virtual-text
            require("nvim-dap-virtual-text").setup({
                enabled                   = true,
                highlight_changed_variables = true,
                show_stop_reason          = true,
                virt_text_pos             = "eol",
                display_callback          = function(variable, _, _, _, options)
                    if options.virt_text_pos == "inline" then
                        return " = " .. variable.value
                    end
                    return variable.name .. " = " .. variable.value
                end,
            })

        end,
    },
}
