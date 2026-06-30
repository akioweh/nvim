local overseer = require("overseer")
local utils = require("overseer.run_utils")
local platform = require("util.platform")

return {
  name = "Run file (g++ + exec)",
  builder = function(params)
    params = params or {}
    local source = params.source or vim.fn.expand("%:p")
    local output = params.output
    if not output then
      local basename = utils.basename(source)
      output = utils.get_out_dir() .. "/" .. basename .. platform.exe_suffix
    end

    return {
      cmd = utils.wrap_command_colorize({ output }),
      components = {
        {
          "dependencies",
          task_names = {
            {
              "Build file (g++)",
              source = source,
              output = output,
              autoskip = true,
            },
          },
        },
        { "open_output", on_start = "always", focus = true, direction = "horizontal" },
        "on_exit_set_status",
      },
    }
  end,

  condition = {
    filetype = { "cpp" },
  },
  tags = { overseer.TAG.RUN },
}
