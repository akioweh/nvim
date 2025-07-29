-- disable batch mode so ssh credentials actually work
vim.env.GIT_SSH_COMMAND = "C:/Windows/System32/OpenSSH/ssh.exe"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "git@github.com:folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "akioweh/LazyVim",
      url = "https://github.com/akioweh/LazyVim.git",
      import = "lazyvim.plugins",
    },
    { import = "plugins" },
  },
  defaults = {
    -- do not lazy load user plugins by default
    lazy = false,
    -- false = track head; "*" = latest release tag
    version = false,
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { -- update auto checker
    enabled = true,
    notify = true,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  git = {
    -- log = { "--since=3 days ago" }, -- show commits from the last 3 days
    log = { "-8" }, -- show the last 8 commits
    timeout = 120, -- git proccess timeout
    url_format = "git@github.com:%s.git",
    cooldown = 10, -- re-fetch (check) cooldown
  },
})
