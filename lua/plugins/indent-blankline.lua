if false then
  require("ibl")
end

---@type LazySpec
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    ---@param opts ibl.config
    opts = function(_, opts)
      opts.indent = {
        char = "▏",
        tab_char = "▏",
      }
    end,
  },
  {
    "catppuccin/nvim",
    optional = true,
    opts = {
      integrations = {
        indent_blankline = {
          scope_color = "rosewater",
          colored_indent_levels = false,
        },
      },
    },
  },
}
