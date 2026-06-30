local M = {}

---helper to locate (and create) an out/ directory
---based on project root (using LazyVim.root)
---@param opts? {buf?:number}
---@return string
function M.get_out_dir(opts)
  opts = opts or {}
  local res = LazyVim.root.get({ buf = opts.buf, normalize = true }) .. "/out"
  vim.fn.mkdir(res, "p")
  return res
end

---check if file is newer than reference
---used to determine if recompilation is needed
---@param file string
---@param reference string
---@return boolean
function M.compare_last_changed(file, reference)
  local source_stat = vim.uv.fs_stat(file)
  local output_stat = vim.uv.fs_stat(reference)
  if not (output_stat and source_stat) then
    return true -- fail true
  end
  return source_stat.mtime.sec > output_stat.mtime.sec
end

function M.basename(path)
  return require("util.platform").basename(path)
end

---*all i wanted was to color the output* :cry:.
---this is the best solution i found to use color to differentiate
---user input echoing vs process stdout in a pty window:
---wrap the command with sed to add color codes
---@param cmd table|string
---@return table
function M.wrap_command_colorize(cmd)
  if type(cmd) == "string" then
    cmd = { cmd } -- table makes cmd run NOT in a shell
  end
  local kind = require("util.platform").shell.kind
  local suf
  if kind == "pwsh" or kind == "powershell" then
    suf = { "|", "ForEach-Object", '{"`e[32m$_`e[0m"}' }
  else
    suf = { "|", "sed", '"s/.*/\\x1b[32m&\\x1b[0m/"' }
  end
  for _, v in ipairs(suf) do
    table.insert(cmd, v)
  end
  return cmd
end

return M
