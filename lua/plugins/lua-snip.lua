return {
  {
    "rafamadriz/friendly-snippets",
    lazy = true, -- friendly-snippets doesn't have a standalone spec in LazyVim so we must mark it lazy manually
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    build = (not LazyVim.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    opts = function()
      return {
        keep_roots = true,
        link_roots = true,
        link_children = true,
        exit_roots = false,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
      }
    end,
    keys = {
      {
        "<Right>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          else
            return "<Right>"
          end
        end,
        mode = { "i", "s" },
        expr = true,
      },
      {
        "<Left>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(-1)
          else
            return "<Left>"
          end
        end,
        mode = { "i", "s" },
        expr = true,
      },
    },
  },
}
