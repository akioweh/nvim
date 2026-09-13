if false then
  require("lazydev")
end

---@type LazySpec
return {
  {
    "folke/lazydev.nvim",
    optional = true,
    ---@param opts lazydev.Config
    opts = function(_, opts)
      opts.enabled = function(root_dir) -- disable if .luarc.json exists
        return not (vim.uv.fs_stat(root_dir .. "/.luarc.json") or vim.uv.fs_stat(root_dir .. "/.luarc.jsonc"))
      end
      vim.list_extend(opts.library, {
        { path = "lazy.nvim", words = { "LazySpec" } },
        { path = "luassert-types/library", words = { "assert" } },
        { path = "busted-types/library", words = { "describe" } },
      })
    end,
  },
  { "LuaCATS/luassert", name = "luassert-types", lazy = true },
  { "LuaCATS/busted", name = "busted-types", lazy = true },
}
