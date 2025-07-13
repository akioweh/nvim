local utils = require("overseer.run_utils")

return {
  name = "C++ build & run (g++)",
  builder = function()
    local basename = vim.fn.expand("%:t:r")
    local output = utils.out_dir .. "/" .. basename .. ".exe"

    return {
      -- First we compile, then (if compilation succeeds) we run the binary
      cmd = { output }, -- this is the command that will be *run*
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
            { "C++ compile (g++)" },
          },
        },
        "on_exit_set_status",
      },
    }
  end,

  condition = { filetype = { "cpp" } },
}
