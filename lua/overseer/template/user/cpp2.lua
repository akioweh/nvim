return {
  name = "compile & run (g++)",
  builder = function()
    return {
      name = "compile & run (g++)",
      cmd = { vim.fn.expand("%:p:r" .. ".exe") },
      components = {
        { "dependencies", task_names = { "compile (g++)" } },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "cpp", "cxx" },
  },
}
