vim.o.breakindent = true
vim.o.showbreak = "↪"
vim.o.breakindentopt = "shift:2,sbr"
vim.o.virtualedit = "onemore,block"
vim.o.softtabstop = -1
vim.o.scrolloff = 7
vim.o.sidescroll = 10
vim.o.sidescrolloff = 2
vim.o.formatoptions = "tcro/qnlj"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

vim.g.lazyvim_python_lsp = "ty"
vim.g.lazyvim_blink_main = true
vim.g.lazyvim_prettier_needs_config = true

local platform = require("util.platform")

local function shell_setup_bash()
  vim.o.shellcmdflag = "-c"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellslash = true

  if platform.is_msys2 then
    vim.env.TMP = "/tmp"
  end
end

local function shell_setup_pwsh()
  vim.o.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned "
    .. "-Command [Console]::InputEncoding=[Console]::"
    .. "OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
  vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.o.shellslash = false
  vim.o.shellpipe = vim.o.shellredir
end

local shell_kind = platform.shell.kind
if shell_kind == "bash" then
  vim.o.shell = vim.o.shell:gsub("\\", "/")
  shell_setup_bash()
elseif shell_kind == "pwsh" or shell_kind == "powershell" then
  shell_setup_pwsh()
elseif shell_kind == "cmd" then
  if vim.fn.executable("pwsh") == 1 then
    -- prefer pwsh
    vim.o.shell = "pwsh"
    shell_setup_pwsh()
  end
end

-- vim.o.shell may have changed above (bash slash-normalize, or cmd -> pwsh), so
-- refresh the platform source of truth for downstream consumers (e.g. overseer).
platform.refresh()
