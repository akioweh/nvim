vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,sbr"
vim.opt.virtualedit = { "onemore", "block" }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.scrolloff = 7
vim.opt.sidescroll = 10
vim.opt.sidescrolloff = 2

vim.g.have_nerd_font = true
vim.g.snacks_animate = false

vim.g.lazyvim_python_lsp = "basedpyright"

-- i spent way too long to figure out why ssh keys aint working in git inside lazy
vim.env.GIT_SSH_COMMAND = "C:/Windows/System32/OpenSSH/ssh.exe"

-- another bruh moment (i thought shellcmdflag is set automatically from shell)
local shell = vim.o.shell or ""
if shell:match("bash$") or shell:match("bash.exe$") then
  -- Set shell options for bash on Windows (or other platforms as needed)
  vim.o.shellcmdflag = "-c"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
  vim.o.shellredir = ">%s 2>&1"
  vim.o.shellslash = true

  ---@diagnostic disable-next-line: undefined-field
  if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.env.TMP = "/tmp"
  end
elseif shell:match("cmd.exe") or shell:match("cmd$") then
  -- try powershell instead
  if vim.fn.executable("pwsh") == 1 then
    vim.o.shell = "pwsh"
    vim.o.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned "
      .. "-Command [Console]::InputEncoding=[Console]::"
      .. "OutputEncoding=[System.Text.Encoding]::UTF8;"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
    vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellslash = false
    vim.o.shellpipe = vim.o.shellredir
  end
end
