if false then
  require("which-key")
end

---@type LazySpec
return {
  {
    "folke/which-key.nvim",
    optional = true,
    ---@param opts wk.Opts
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      -- extra-strength hiding (which_key_ignore) is ignored for <Nop>s
      opts.spec[#opts.spec + 1] = {
        mode = { "n", "x" },
        { "<C-w>h", hidden = true },
        { "<C-w>H", hidden = true },
        { "<leader>wh", hidden = true },
        { "<leader>wH", hidden = true },
      }
    end,
    keys = {
      { "<leader>wh", "<Nop>", mode = { "n", "x" }, desc = "which_key_ignore" },
      { "<leader>wH", "<Nop>", mode = { "n", "x" }, desc = "which_key_ignore" },
    },
  },
}
