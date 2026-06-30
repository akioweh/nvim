local overseer = require("overseer")
local utils = require("overseer.run_utils")
local platform = require("util.platform")

return {
  name = "Run file (python)",
  builder = function(params)
    params = params or {}
    local source = params.source or vim.fn.expand("%:p")

    return {
      cmd = utils.wrap_command_colorize({
        params.python or (platform.is_windows and "py" or "python3"),
        source,
      }),
      components = {
        { "open_output", on_start = "always", focus = true, direction = "horizontal" },
        "on_exit_set_status",
      },
    }
  end,

  condition = {
    filetype = { "python" },
  },
  tags = { overseer.TAG.RUN },
}
