---@type LazySpec
return {
  {
    "mrjones2014/codesettings.nvim",
    lazy = false,
    opts = {
      config_file_paths = {
        ".vscode/settings.json",
        "codesettings.json",
        "lspsettings.json",
        ".lspconfig.json",
        ".lspconfig.jsonc",
      },
      root_dir = require("lazyvim.util").root(),
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        ---@type vim.lsp.Config
        ["*"] = {
          before_init = function(_, config)
            local codesettings = require("codesettings")
            codesettings.with_local_settings(config.name, config)
          end,
        },
      },
    },
  },
}
