local utils = require("overseer.run_utils")

return {
  name = "Run file (python)",
  builder = function(params)
    params = params or {}
    local source = params.source or vim.fn.expand("%:p")

    return {
      cmd = utils.wrap_command_colorize({
        params.python or "python",
        source,
      }),
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
