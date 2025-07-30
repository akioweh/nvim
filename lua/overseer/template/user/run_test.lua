local utils = require("overseer.run_utils")

return {
  name = "C++ run file",
  builder = function()
    local basename = vim.fn.expand("%:t:r")
    local output = utils.out_dir .. "/" .. basename .. ".exe"

    return {
      cmd = { output },
      strategy = {
        "runwindow",
      },

      components = {
        {
          "dependencies",
          task_names = {
            { "C++ compile (g++)" },
          },
        },
        { "open_output", focus = true, direction = "horizontal" },
        "on_exit_set_status",
      },
    }
  end,

  condition = { filetype = { "cpp" } },
}
