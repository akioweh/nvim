---@type LazySpec
return {
  {
    "mrjones2014/codesettings.nvim",
    enabled = false,
    ft = { "json", "jsonc", "lua" },
    opts = {
      config_file_paths = {
        ".vscode/settings.json",
        "codesettings.json",
        "lspsettings.json",
        ".lspconfig.json",
        ".lspconfig.jsonc",
      },
      jsonls_integration = true,
      lua_ls_integration = true,
      jsonc_filetype = true,
      live_reload = true,
      root_dir = require("lazyvim.util").root(),
      merge_lists = "append",
    },
  },
}
