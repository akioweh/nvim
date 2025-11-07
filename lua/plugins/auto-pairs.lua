return {
  { "nvim-mini/mini.pairs", enabled = false },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
      bs = {
        delete_from_end = false,
      },
    },
  },
}
