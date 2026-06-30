---@type LazySpec
return {
  {
    "Civitasv/cmake-tools.nvim",
    config = function(_, opts)
      require("cmake-tools").setup(opts)
      local osys = require("cmake-tools.osys")
      local platform = require("util.platform")
      -- msys2 -> linux-like build behavior; native Windows -> win32
      osys.iswin32 = platform.is_windows
      osys.islinux = not platform.is_windows
    end,
  },
}
