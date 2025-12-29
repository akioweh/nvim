local overseer = require("overseer")
local utils = require("overseer.run_utils")

---@type overseer.TemplateFileDefinition
return {
  name = "Build file (g++)",
  builder = function(params)
    params = params or {}
    local source = params.source or vim.fn.expand("%:p")
    local output = params.output
    if not output then
      local basename = utils.basename(source)
      output = utils.get_out_dir() .. "/" .. basename .. ".exe"
    end

    if params.autoskip and not utils.compare_last_changed(source, output) then
      vim.notify("No changes detected, skipping recompilation.", vim.log.levels.INFO)
      return {
        name = "C++ compile (g++) (skipped)",
        cmd = { "echo" },
        args = { "Autoskipped build" },
        components = {
          "on_exit_set_status",
          { "on_complete_dispose", timeout = 1 },
        },
      }
    end

    return {
      cmd = { "g++" },
      args = {
        "-std=" .. (params.std or "c++23"),
        "-O" .. (params.O or "2"),
        "-Wall",
        "-W",
        source,
        "-o",
        output,
      },
      components = {
        {
          "on_output_quickfix",
          open_on_exit = "failure",
          set_diagnostics = true, -- show compiler errors
          tail = true,
        },
        "default",
      },
    }
  end,
  priority = 60, -- appear lower
  params = {
    std = {
      type = "enum",
      name = "std",
      order = 1,
      optional = true,
      choices = { "c++23", "c++17", "c++11" },
      default = "c++23",
    },
    O = {
      type = "enum",
      name = "Optimization level",
      order = 2,
      optional = true,
      choices = { "0", "1", "2", "3", "s", "z" },
      default = "2",
    },
  },
  condition = {
    filetype = { "cpp" },
  },
  tags = { overseer.TAG.BUILD },
}
