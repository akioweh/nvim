vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.breakindentopt = "shift:2,sbr"

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal shiftwidth< tabstop< breakindentopt<"
