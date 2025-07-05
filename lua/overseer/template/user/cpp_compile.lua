return {
  name = "compile (g++)",
  builder = function()
    return {
      name = "compile (g++)",
      cmd = { "g++" },
      args = {
        "-std=c++23",
        "-O2",
        "-Wall",
        "-W",
        vim.fn.expand("%:p"),
        "-o",
        vim.fn.expand("%:t:r" .. ".exe"),
      },
      components = {
        { "on_output_quickfix", open_on_exit = "failure", set_diagnostics = true }, -- show compiler errors
        "default",
      },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
