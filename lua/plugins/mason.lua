---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local tools = require("util.tools")

      -- Source each tool per the active strategy: "smart" keeps system installs
      -- and only Mason-installs the gaps; "mason" installs everything.
      opts.ensure_installed = vim.tbl_filter(function(pkg)
        return tools.use_mason(pkg)
      end, opts.ensure_installed or {})

      -- (Previously the tbl_deep_extend result was discarded, so PATH/pip never
      -- took effect — assign directly.)
      opts.PATH = tools.mason_path_mode()
      opts.pip = vim.tbl_deep_extend("force", opts.pip or {}, { upgrade_pip = true })
    end,
  },
}
