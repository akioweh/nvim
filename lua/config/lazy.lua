-- For reasons still unclear to me, on Windows I have to
-- specify the ssh executable with an absolute path.
-- Otherwise ssh-agent is skipped and authentication will fail
if vim.fn.has("win32") == 1 then
  vim.env.GIT_SSH_COMMAND = "C:/Windows/System32/OpenSSH/ssh.exe -o BatchMode=yes"
end

-- use ssh for git?
local use_ssh = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = use_ssh and "git@github.com:folke/lazy.nvim.git" or "https://github.com/folke/lazy.nvim.git"
  local result = vim
    .system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }, { text = true })
    :wait()
  if result.code ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { result.stdout or "", "WarningMsg" },
      { result.stderr or "", "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(result.code)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.lazyvim_check_order = false

require("lazy").setup({
  spec = {
    {
      "akioweh/LazyVim",
      name = "LazyVim",
      -- dir = "K:/projects/LazyVim",
      -- url = "https://github.com/akioweh/LazyVim.git",
      import = "lazyvim.plugins",
    },
    { import = "plugins" },
  },
  dev = {
    path = "K:/projects/nvim-plugins/",
    patterns = { "akioweh" },
    fallback = true,
  },
  defaults = {
    -- do not lazy load user plugins by default
    lazy = false,
    -- false = track head; "*" = latest release tag
    version = nil,
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
        "netrwPlugin",
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
    url_format = use_ssh and "git@github.com:%s.git" or nil,
    cooldown = 10, -- re-fetch (check) cooldown
  },
})
