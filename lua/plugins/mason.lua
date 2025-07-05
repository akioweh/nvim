return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.tbl_deep_extend("force", opts, {
        PATH = "append",
        pip = { upgrade_pip = true },
      })

      opts.ensure_installed = vim.tbl_filter(function(pkg)
        return pkg ~= "haskell-debug-adapter" and pkg ~= "haskell-language-server"
      end, opts.ensure_installed or {})
    end,
  },
}
