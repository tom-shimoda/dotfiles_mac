local opt = vim.opt

opt.swapfile      = false
opt.backup        = false
opt.undofile      = false
opt.colorcolumn   = "120"
opt.updatetime    = 300
opt.termguicolors = true
opt.ignorecase    = true
opt.smartcase     = true
opt.number        = true
opt.wrap          = false
opt.mouse         = "a"
opt.tabstop       = 4
opt.shiftwidth    = 4
opt.expandtab     = true
opt.shiftround    = true
opt.hidden        = true
opt.completeopt   = { "menu", "menuone", "noselect" }
opt.cursorline    = true
opt.listchars     = { eol = "↩", tab = "»-", trail = "_" }
opt.list          = true
opt.clipboard     = "unnamed"

vim.g.python3_host_prog = "/usr/bin/python3"
