---@type LazySpec
return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      local tools = require("util.tools")

      -- Exclude any adapter that should be sourced from the system (per strategy).
      local excludes = {}
      for _, adapter in ipairs(opts.ensure_installed or {}) do
        if not tools.use_mason(tools.dap_alias[adapter] or adapter) then
          excludes[#excludes + 1] = adapter
        end
      end

      opts.ensure_installed = vim.tbl_filter(function(item)
        return not vim.tbl_contains(excludes, item)
      end, opts.ensure_installed or {})

      opts.automatic_installation = { exclude = excludes }
    end,
  },
}
