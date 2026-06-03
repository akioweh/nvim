if false then
  require("lt-utils")
end

---@type LazySpec
return {
  {
    "akioweh/lt-utils.nvim",
    dev = true,
    lazy = false,
    ---@type LtUtils.config
    opts = {
      default_scope = "project",
    },
  },
}
