return {
  name = "Python run file",
  builder = function()
    local source = vim.fn.expand("%:p")
    local basename = vim.fn.expand("%:t:r")
    return {
      name = "Python run file",
      cmd = {
        "python",
        source,
      },
      strategy = {
        "toggleterm",
        -- id = "py_run_" .. basename,
        direction = "horizontal",
        size = 15,
        open_on_start = true,
        quit_on_exit = "never",
        close_on_exit = false,
      },
      components = {
        "on_exit_set_status",
      },
    }
  end,

  condition = {
    filetype = { "python" },
  },
}
