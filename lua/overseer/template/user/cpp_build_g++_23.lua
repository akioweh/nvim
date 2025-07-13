local utils = require("overseer.run_utils")

return {
  name = "C++ compile (g++)",
  builder = function()
    local source = vim.fn.expand("%:p")
    local basename = vim.fn.expand("%:t:r")
    local output = utils.out_dir .. "/" .. basename .. ".exe"

    if not utils.needs_recompile(source, output) then
      vim.notify("No changes detected, skipping recompilation.", vim.log.levels.INFO)
      return {
        name = "C++ compile (g++) (skipped)",
        cmd = { "echo" },
        args = { "Autoskipped build" },
        components = {
          "on_exit_set_status",
          { "on_complete_dispose", timeout = 1 },
        },
      }
    end

    return {
      name = "C++ compile (g++)",
      cmd = { "g++" },
      args = {
        "-std=c++23",
        "-O2",
        "-Wall",
        "-W",
        source,
        "-o",
        output,
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
