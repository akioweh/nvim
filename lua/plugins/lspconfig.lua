---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- these exist only as integration with LazyVim's
      -- custom lspconfig setup (see LazyVim/lua/lazyvim/plugins/lsp/init.lua)
      ---@type table<string, vim.lsp.Config>
      servers = {
        clangd = {
          mason = false,
        },
        hls = {
          mason = false,
        },
        ty = {
          mason = false,
        },
        pyright = {
          enabled = false,
          mason = false,
        },
        basedpyright = {
          enabled = false,
          mason = false,
        },
        ruff = {
          enabled = true,
          mason = false,
        },
        pylsp = {
          enabled = false,
          mason = false,
        },
        tinymist = {
          mason = false,
        },
        lua_ls = {
          mason = false,
        },
      },
      diagnostics = {
        virtual_text = {
          prefix = "icons",
        },
      },
    },
  },
}
