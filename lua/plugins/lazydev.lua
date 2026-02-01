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
