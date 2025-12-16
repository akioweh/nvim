if false then
  require("lazydev")
end

---@type LazySpec
return {
  {
    "folke/lazydev.nvim",
    optional = true,
    ---@type lazydev.Config
    opts = {
      library = {
        { path = "lazy.nvim", words = { "LazySpec" } },
      },
    },
  },
}
