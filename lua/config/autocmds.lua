local cac = vim.api.nvim_create_autocmd

cac("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.breakindent = true
    vim.opt_local.breakindentopt = "shift:2,sbr"
  end,
})

cac("FileType", {
  pattern = { "cpp", "c", "cxx", "h", "hpp" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.breakindentopt = "shift:2,sbr"
  end,
})

cac("VimLeave", {
  callback = function()
    vim.fn.system("echo -ne '\\e[6 q'")
  end,
})

cac("FileType", {
  group = vim.api.nvim_create_augroup("FzfLuaEsc", { clear = true }),
  pattern = "fzf",
  callback = function(e)
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n><C-w>c", { buffer = e.buf, silent = true, nowait = true })
  end,
})
