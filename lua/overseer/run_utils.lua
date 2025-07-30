local lazyvim_util = require("lazyvim.util")
local M = {}

---helper to locate (and create) an out/ directory
---@param opts? {buf?:number}
---@return string
function M.get_out_dir(opts)
  opts = opts or {}
  local res = lazyvim_util.root.get({ buf = opts.buf, normalize = true }) .. "/out"
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
  local name = path:match("([^/]+)$")
  if not name then
    return ""
  end
  name = name:match("(.+)%.[^%.]+$") or name
  return name
end

---*all i wanted was to color the output* :cry:
---@param cmd table|string
---@return table
function M.wrap_command_colorize(cmd)
  if type(cmd) == "string" then
    cmd = { cmd }
  end
  local shell = vim.o.shell:gsub("%.exe$", "")
  local suf
  if shell:match("pwsh$") or shell:match("powershell$") then
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
