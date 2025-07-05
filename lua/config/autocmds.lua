-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.breakindent = true
    vim.opt_local.breakindentopt = "shift:2,sbr"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c", "cxx", "h", "hpp" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.breakindentopt = "shift:2,sbr"
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.fn.system("echo -ne '\\e[6 q'")
  end,
})
