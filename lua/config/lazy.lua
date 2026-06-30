-- Machine-local overrides (optional, gitignored `config/local.lua`). Loaded
-- first so it can set env vars (NVIM_DEV_PATH, ...) and flags that platform and
-- lazy read below. See config/local.lua.example.
pcall(require, "config.local")

local platform = require("util.platform")

-- Due to lazy.nvim bug (#2012), on native Windows we must specify the ssh
-- executable with an absolute path; otherwise ssh-agent is skipped and
-- authentication fails. (Under msys2, git uses the msys ssh-agent, so skip this.)
if platform.is_windows then
  vim.env.GIT_SSH_COMMAND = "C:/Windows/System32/OpenSSH/ssh.exe -o BatchMode=yes"
end

-- Use ssh for git operations? Default off (https) so a machine without ssh keys
-- / agent set up doesn't hang. Opt in per machine: vim.g.use_ssh = true.
local use_ssh = vim.g.use_ssh == true

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
      import = "lazyvim.plugins",
    },
    { import = "plugins" },
  },
  dev = {
    path = platform.dev_path,
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
  checker = { -- periodic update check (network). Set vim.g.auto_update = false to
    -- disable it (offline machines / tests, which would otherwise hang on fetch).
    enabled = vim.g.auto_update ~= false,
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
