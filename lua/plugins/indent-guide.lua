if false then
  require("ibl")
  require("blink.indent")
end

---@type LazySpec
return {
  {
    "saghen/blink.indent",
    --- @module 'blink.indent'
    --- @type blink.indent.Config
    opts = {
      blocked = {
        -- default: 'terminal', 'quickfix', 'nofile', 'prompt'
        buftypes = { include_defaults = true },
        -- default: 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'gitcommit', 'dashboard', ''
        filetypes = { include_defaults = true },
      },
      mappings = {
        -- which lines around the scope are included for 'ai': 'top', 'bottom', 'both', or 'none'
        border = "both",
        -- set to '' to disable
        -- textobjects (e.g. `y2ii` to yank current and outer scope)
        object_scope = "ii",
        object_scope_with_border = "oi",
        -- motions
        -- snacks sets these (i think?)
        -- goto_top = "[i",
        -- goto_bottom = "]i",
      },
      static = {
        enabled = true,
        char = "▏",
        whitespace_char = nil, -- inherits from `vim.opt.listchars:get().space` when `nil` (see `:h listchars`)
        priority = 1,
        -- specify multiple highlights here for rainbow-style indent guides
        -- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
        highlights = { "BlinkIndent" },
      },
      scope = {
        enabled = true,
        char = "▏",
        priority = 1000,
        -- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
        -- highlights = { 'BlinkIndentScope' },
        highlights = {
          "BlinkIndentRed",
          "BlinkIndentOrange",
          "BlinkIndentYellow",
          "BlinkIndentGreen",
          "BlinkIndentCyan",
          "BlinkIndentBlue",
          "BlinkIndentViolet",
        },
        -- enable to show underlines on the line above the current scope
        underline = {
          enabled = false,
          highlights = {
            "BlinkIndentRedUnderline",
            "BlinkIndentOrangeUnderline",
            "BlinkIndentYellowUnderline",
            "BlinkIndentGreenUnderline",
            "BlinkIndentCyanUnderline",
            "BlinkIndentBlueUnderline",
            "BlinkIndentVioletUnderline",
          },
        },
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
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
  {
    "snacks.nvim",
    opts = {
      indent = { enabled = false },
    },
  },
}
