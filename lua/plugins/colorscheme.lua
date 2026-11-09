---@type LazySpec
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavor = "mocha",
      -- transparent_background = true,
      auto_integrations = true,
      custom_highlights = function(colors)
        local blend = require("catppuccin.utils.colors").blend
        local read = blend(colors.green, colors.surface1, 0.10)
        local write = blend(colors.red, colors.surface1, 0.10)
        return {
          LspReferenceRead = { bg = read },
          LspReferenceWrite = { bg = write },
          LspReferenceTextMark = { fg = colors.surface1 },
          LspReferenceReadMark = { fg = read },
          LspReferenceWriteMark = { fg = write },
        }
      end,
    },
  },
  {
    "akioweh/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
}
