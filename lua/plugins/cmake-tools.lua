---@type LazySpec
return {
  {
    "Civitasv/cmake-tools.nvim",
    config = function(_, opts)
      require("cmake-tools").setup(opts)
      local osys = require("cmake-tools.osys")
      osys.islinux = true
      osys.iswin32 = false
    end,
  },
}
