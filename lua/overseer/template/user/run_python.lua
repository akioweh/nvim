local overseer = require("overseer")
local utils = require("overseer.run_utils")

return {
  name = "Run file (python)",
  builder = function(params)
    params = params or {}
    local source = params.source or vim.fn.expand("%:p")

    return {
      cmd = utils.wrap_command_colorize({
        params.python or (vim.fn.has("win32") and "py" or "python3"),
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
