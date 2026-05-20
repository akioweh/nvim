if false then
  require("origami")
end

---@type LazySpec
return {
  {
    "chrisgrieser/nvim-origami",
    keys = {
      {
        "j",
        function()
          require("origami").h()
        end,
      },
      {
        "l",
        function()
          require("origami").l()
        end,
      },
      {
        "L",
        function()
          local on_fold = vim.fn.foldclosed(".") > -1
          if on_fold then
            return "zO"
          end
          if vim.v.count == 0 then
            return "g$"
          end
          return "j$"
        end,
        expr = true,
        silent = true,
      },
    },
    init = function()
      -- disable vanilla auto-folding
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    ---@type Origami.config
    opts = {
      useLspFoldsWithTreesitterFallback = { enabled = false },
      foldKeymaps = {
        setup = false,
      },
    },
  },
}
