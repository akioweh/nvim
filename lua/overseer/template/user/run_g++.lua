local utils = require("overseer.run_utils")

return {
  name = "Run file (g++ + exec)",
  builder = function(params)
    params = params or {}
    local source = params.source or vim.fn.expand("%:p")
    local output = params.output
    if not output then
      local basename = utils.basename(source)
      output = utils.get_out_dir() .. "/" .. basename .. ".exe"
    end

    return {
      cmd = utils.wrap_command_colorize(output),
      strategy = { -- run it inside a terminal split
        "toggleterm",
        -- id = "cpp_run_" .. basename,
        -- shell = true,
        direction = "horizontal",
        size = 15,
        open_on_start = true,
        quit_on_exit = "never",
        close_on_exit = false,
      },

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
        "on_exit_set_status",
      },
    }
  end,

  condition = { filetype = { "cpp" } },
}
