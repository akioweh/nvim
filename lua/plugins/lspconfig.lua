---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = {
      -- these options exist only to integrate with LazyVim's
      -- custom lspconfig setup (see LazyVim/lua/lazyvim/plugins/lsp/init.lua).
      -- specifically, keys in `servers` are auto-enabled (or disabled)
      -- and also kept away from LazyVim's mason auto-install with `mason = false`.

      ---@type table<string, vim.lsp.Config>
      servers = {
        clangd = { mason = false },
        hls = { mason = false },
        ty = { mason = false },
        tinymist = { mason = false },
        lua_ls = { mason = false },
        pyright = { enabled = false, mason = false },
        basedpyright = { enabled = false, mason = false },
        ruff = { enabled = true, mason = false },
        pylsp = { enabled = false, mason = false },
        ltex_plus = { mason = false },
        panache = { mason = false },
      },
      -- this is passed to vim.diagnostic.config() by LazyVim
      diagnostics = {
        virtual_text = {
          prefix = "icons",
        },
      },
    },
  },
}
