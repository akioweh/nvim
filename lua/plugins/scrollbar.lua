if false then
  require("scrollbar")
end

---@type LazySpec
return {
  {
    "petertriho/nvim-scrollbar",
    branch = "refactor/v2",
    lazy = true,
    event = "LazyFile",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    ---@type ScrollbarUserConfig
    opts = {
      exclude = {
        filetypes = {
          ["neo-tree"] = true,
        },
      },
      scrollbar = {
        preset = "intellij",
        unit = "screenline",
        throttle_ms = 20,
        window = { wo = { winblend = 30 } },
      },
      providers = {
        cursor = false,
        gitsigns = true,
      },
      marks = {
        GitAdd = {
          text = "▕",
        },
        GitChange = {
          text = "▕",
        },
      },
    },
    config = function(_, opts)
      --- make git mark cells have transparent background
      local function set_highlights()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        vim.api.nvim_set_hl(0, "ScrollbarBase", { fg = normal.fg, bg = "NONE", blend = 100 })
        for _, kind in ipairs({ "Add", "Change", "Delete" }) do
          local highlight = vim.api.nvim_get_hl(0, { name = "GitSigns" .. kind, link = false })
          ---@diagnostic disable-next-line: assign-type-mismatch
          highlight.bg = "NONE"
          highlight.blend = 0
          vim.api.nvim_set_hl(0, "ScrollbarGit" .. kind, highlight)
        end
      end

      require("scrollbar").setup(opts)
      set_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("scrollbar_transparency", { clear = true }),
        callback = set_highlights,
      })
    end,
  },
}
