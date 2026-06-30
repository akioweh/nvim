local tools = require("util.tools")

---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- these options exist only to integrate with LazyVim's
      -- custom lspconfig setup (see LazyVim/lua/lazyvim/plugins/lsp/init.lua).
      -- specifically, keys in `servers` are auto-enabled (or disabled)
      -- and also kept away from LazyVim's mason auto-install with `mason = false`.

      ---@type table<string, vim.lsp.Config>
      servers = {
        clangd = { mason = tools.use_mason("clangd") },
        hls = { mason = tools.use_mason("hls") },
        ty = { mason = tools.use_mason("ty") },
        tinymist = { mason = tools.use_mason("tinymist") },
        lua_ls = { mason = tools.use_mason("lua_ls") },
        pyright = { enabled = false, mason = tools.use_mason("pyright") },
        basedpyright = { enabled = false, mason = tools.use_mason("basedpyright") },
        ruff = { enabled = true, mason = tools.use_mason("ruff") },
        pylsp = { enabled = false, mason = tools.use_mason("pylsp") },
        ltex_plus = { mason = tools.use_mason("ltex_plus") },
        panache = { mason = false }, -- custom server, no Mason package
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
