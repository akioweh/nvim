return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- List of packages to exclude from automatic installation
      local exclude_packages = {
        "haskell-debug-adapter",
        "haskell-language-server",
        "debugpy",
        "clangd",
        "pyright",
        "basedpyright",
        "ruff",
      }

      vim.tbl_deep_extend("force", opts, {
        PATH = "append",
        pip = { upgrade_pip = true },
      })

      opts.ensure_installed = vim.tbl_filter(function(pkg)
        return not vim.tbl_contains(exclude_packages, pkg)
      end, opts.ensure_installed or {})
    end,
  },
}
