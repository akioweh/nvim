vim.opt_local.wrap = true
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "shift:2,sbr"

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal wrap< breakindent< breakindentopt<"
