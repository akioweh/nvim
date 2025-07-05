return {
  name = "C++ build & run",
  builder = function()
    local file = vim.fn.expand("%:p")
    local outfile = vim.fn.expand("%:t:r") .. ".exe"

    return {
      -- First we compile, then (if compilation succeeds) we run the binary
      cmd = { "./" .. outfile }, -- this is the command that will be *run*
      strategy = { -- run it inside a terminal split
        "toggleterm",
        shell = true,
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
            { "compile (g++)" },
          },
        },
        "default",
      },
    }
  end,

  condition = { filetype = { "cpp" } },
}
