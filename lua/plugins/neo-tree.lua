local function safe_delete(path)
  local cmd = "powershell.exe -NoProfile -Command \"Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile('"
    .. path
    .. "', 'OnlyErrorDialogs', 'SendToRecycleBin')\""
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
          -- Override for visual (multi-select) delete
          delete_visual = function(state, selected_nodes)
            -- Count selected nodes for confirmation message
            local count = 0
            for _ in pairs(selected_nodes) do
              count = count + 1
            end
            local msg = "Are you sure you want to move " .. count .. " items to the Recycle Bin?"
            local choice = vim.fn.confirm(msg, "&Yes\n&No", 2)
            if choice ~= 1 then
              return
            end
            for _, node in ipairs(selected_nodes) do
              local path = node:get_id()
              safe_delete(path)
            end
            require("neo-tree.sources.manager").refresh(state.name)
          end,
        },
      },
    },
  },
}
