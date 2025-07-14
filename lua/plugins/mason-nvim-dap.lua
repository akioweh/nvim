return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      local excludes = {
        "python",
      }

      opts.ensure_installed = vim.tbl_filter(function(item)
        return not vim.tbl_contains(excludes, item)
      end, opts.ensure_installed or {})

      opts.automatic_installation = { exclude = excludes }
    end,
  },
}
