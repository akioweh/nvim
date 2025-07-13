local function safe_delete(path)
  local cmd = 'powershell.exe -NoProfile -NoLogo -Command "'
    .. "$shell = New-Object -ComObject Shell.Application; "
    .. "$item = $shell.Namespace(0).ParseName('"
    .. path
    .. "'); "
    .. "if ($item) { $item.InvokeVerb('delete') }\""
  vim.fn.system(cmd)
end

-- For better performance with multiple deletions
local function safe_delete_batch(paths)
  if #paths == 0 then
    return
  end

  local paths_str = ""
  for i, path in ipairs(paths) do
    paths_str = paths_str .. "'" .. path .. "'"
    if i < #paths then
      paths_str = paths_str .. ","
    end
  end

  local cmd = 'powershell.exe -NoProfile -NoLogo -Command "'
    .. "$shell = New-Object -ComObject Shell.Application; "
    .. "$paths = @("
    .. paths_str
    .. "); "
    .. "foreach ($path in $paths) { "
    .. "$item = $shell.Namespace(0).ParseName($path); "
    .. "if ($item) { $item.InvokeVerb('delete') } }\""
  vim.fn.system(cmd)
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "left",
        width = 28,
        mappings = {
          ["j"] = function(state)
            local node = state.tree:get_node()
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end,
        },
      },
      filesystem = {
        commands = {
          -- Override for single delete
          delete = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            safe_delete(path)
            require("neo-tree.sources.manager").refresh(state.name)
          end,
          -- Override for visual (multi-select) delete with batching
          delete_visual = function(state, selected_nodes)
            local count = 0
            local paths = {}
            for _ in pairs(selected_nodes) do
              count = count + 1
            end
            for _, node in ipairs(selected_nodes) do
              table.insert(paths, node:get_id())
            end

            local msg = "Are you sure you want to move " .. count .. " items to the Recycle Bin?"
            local choice = vim.fn.confirm(msg, "&Yes\n&No", 2)
            if choice ~= 1 then
              return
            end

            safe_delete_batch(paths)
            require("neo-tree.sources.manager").refresh(state.name)
          end,
        },
      },
    },
  },
}
