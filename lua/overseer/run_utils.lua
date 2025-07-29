local M = {}

M.project_root = vim.fn.getcwd()

M.out_dir = M.project_root .. "/out"
vim.fn.mkdir(M.out_dir, "p")

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

-- Highlight groups for input/output coloring
vim.api.nvim_set_hl(0, "RunInput", { fg = "#87afff" })
vim.api.nvim_set_hl(0, "RunOutput", { fg = "#d7d7d7" })

-- Namespace for extmarks
M.ns = vim.api.nvim_create_namespace("runio")

return M
