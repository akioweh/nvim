local log = require("neo-tree.log")
local events = require("neo-tree.events")
local inputs = require("neo-tree.ui.inputs")
local utils = require("neo-tree.utils")

-- copied from neo-tree/sources/filesystem/lib/fs_actions.lua
local function find_replacement_buffer(for_buf)
  local bufs = vim.api.nvim_list_bufs()

  -- make sure the alternate buffer is at the top of the list
  local alt = vim.fn.bufnr("#")
  if alt ~= -1 and alt ~= for_buf then
    table.insert(bufs, 1, alt)
  end

  -- find the first valid real file buffer
  for _, buf in ipairs(bufs) do
    if buf ~= for_buf then
      local is_valid = vim.api.nvim_buf_is_valid(buf)
      if is_valid then
        local buftype = vim.bo[buf].buftype
        if buftype == "" then
          return buf
        end
      end
    end
  end
  return -1
end
local function clear_buffer(path)
  local buf = utils.find_buffer_by_name(path)
  if buf < 1 then
    return
  end
  local alt = find_replacement_buffer(buf)
  -- Check all windows to see if they are using the buffer
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
      -- if there is no alternate buffer yet, create a blank one now
      if alt < 1 or alt == buf then
        alt = vim.api.nvim_create_buf(true, false)
      end
      -- replace the buffer displayed in this window with the alternate buffer
      vim.api.nvim_win_set_buf(win, alt)
    end
  end
  local success, msg = pcall(vim.api.nvim_buf_delete, buf, { force = true })
  if not success then
    log.error("Could not clear buffer: ", msg)
  end
end

local delete_node = function(path, callback)
  log.trace("Recycling node: ", path)

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

    local res = vim.system({ "rb", path }, { text = true }):wait()
    if res.code ~= 0 then
      local out = res.stdout
      if res.stderr ~= "" then
        out = res.stderr .. "\n\n" .. out
      end
      log.error("Could not recycle '", path, "':\n", out)
      return
    end
    log.info("Recycled '", path, "'")

    clear_buffer(path)
    complete()
  end

  do_delete()
end

local delete_nodes = function(paths_to_delete, callback)
  local msg = "Are you sure you want to recycle " .. #paths_to_delete .. " items?"
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

---@type LazySpec
return {
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    priority = 400,
    init = nil,
    opts = {
      -- popup_border_style = "",
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
      source_selector = {
        winbar = true,
        statusline = true,
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
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
          ---@diagnostic disable-next-line: unused-local
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
