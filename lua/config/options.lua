vim.o.breakindent = true
vim.o.breakindentopt = "shift:2,sbr"
vim.o.virtualedit = "onemore,block"
vim.o.scrolloff = 7
vim.o.sidescroll = 10
vim.o.sidescrolloff = 2
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_blink_main = true

local function shell_setup_bash()
  vim.o.shellcmdflag = "-c"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellslash = true

  ---@diagnostic disable-next-line: undefined-field
  if vim.uv.os_uname().sysname == "Windows_NT" then
    vim.env.TMP = "/tmp"
  end
  vim.g.is_linux = true
  vim.g.is_win32 = false
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

local function match_end(str, suf)
  return str:match(suf .. "$") or str:match(suf .. "%.exe$")
end

local shell = vim.o.shell or ""
if match_end(shell, "bash") then
  vim.o.shell = shell:gsub("\\", "/")
  shell_setup_bash()
elseif match_end(shell, "pwsh") then
  shell_setup_pwsh()
elseif match_end(shell, "cmd") then
  if vim.fn.executable("pwsh") == 1 then
    -- prefer pwsh
    vim.o.shell = "pwsh"
    shell_setup_pwsh()
  end
end
