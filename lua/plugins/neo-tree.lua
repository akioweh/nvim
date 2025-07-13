local uv = vim.uv
local log = require("neo-tree.log")
local events = require("neo-tree.events")
local inputs = require("neo-tree.ui.inputs")

local function safe_delete(path)
  local cmd = "powershell.exe -NoProfile -NoLogo -Command \"Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile('"
    .. vim.fn.shellescape(path)
    .. "', 'OnlyErrorDialogs', 'SendToRecycleBin')\""
  return vim.fn.system(cmd)
end

local function safe_delete_dir(path)
  local cmd = "powershell.exe -NoProfile -NoLogo -Command \"Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory('"
    .. vim.fn.shellescape(path)
    .. "', 'OnlyErrorDialogs', 'SendToRecycleBin')\""
  return vim.fn.system(cmd)
end

local delete_node = function(path, callback)
  log.trace("Recycling node: ", path)
  local _type = "unknown"
  local stat = uv.fs_stat(path)
  if stat then
    _type = stat.type
  else
    log.warn("Could not read file/dir:", path, stat, ", attempting to recycle anyway...")
    -- Guess the type by whether it appears to have an extension
    if path:match("%.(.+)$") then
      _type = "file"
    else
      _type = "directory"
    end
    return
  end

  local do_delete = function()
    local complete = vim.schedule_wrap(function()
      events.fire_event(events.FILE_DELETED, path)
      if callback then
        callback(path)
      end
    end)

    local event_result = events.fire_event(events.BEFORE_FILE_DELETE, path) or {}
    if event_result.handled then
      complete()
      return
    end

    if _type == "directory" then
      local result = safe_delete_dir(path)
      local error = vim.v.shell_error
      if error ~= 0 then
        log.debug("Could not recycle directory '", path, "': ", result)
      else
        log.info("Recycled directory ", path)
      end
    else
      local result = safe_delete(path)
      local error = vim.v.shell_error
      if error ~= 0 then
        log.debug("Could not recycle file '", path, "': ", result)
      else
        log.info("Recycled file ", path)
      end
    end
    complete()
  end

  do_delete()
end

local delete_nodes = function(paths_to_delete, callback)
  local msg = "Are you sure you want to reccle " .. #paths_to_delete .. " items?"
  inputs.confirm(msg, function(confirmed)
    if not confirmed then
      return
    end

    for _, path in ipairs(paths_to_delete) do
      delete_node(path, nil)
    end

    if callback then
      vim.schedule(function()
        callback(paths_to_delete[#paths_to_delete])
      end)
    end
  end)
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
          delete = function(state, callback)
            local node = assert(state.tree:get_node())
            if node.type ~= "file" and node.type ~= "directory" then
              log.warn("The `delete` command can only be used on files and directories")
              return
            end
            if node:get_depth() == 1 then
              log.error(
                "Will not delete root node "
                  .. node.path
                  .. ", please back out of the current directory if you want to delete the root node."
              )
              return
            end
            delete_node(node.path, callback)
          end,
          -- Override for visual (multi-select) delete
          delete_visual = function(state, selected_nodes, callback)
            local paths_to_delete = {}
            for _, node_to_delete in pairs(selected_nodes) do
              if node_to_delete:get_depth() == 1 then
                log.error(
                  "Will not delete root node "
                    .. node_to_delete.path
                    .. ", please back out of the current directory if you want to delete the root node."
                )
                return
              end

              if node_to_delete.type == "file" or node_to_delete.type == "directory" then
                table.insert(paths_to_delete, node_to_delete.path)
              end
            end
            delete_nodes(paths_to_delete, callback)
          end,
        },
      },
    },
  },
}
