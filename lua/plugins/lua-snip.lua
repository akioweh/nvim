local jsregexp_build_command = "make install_jsregexp LUA_LDLIBS='-lluajit-5.1'" -- link against luajit instead of lua

---@type LazySpec
return {
  {
    "rafamadriz/friendly-snippets",
    optional = true,
    lazy = true, -- friendly-snippets doesn't have a standalone spec in LazyVim so we must mark it lazy manually
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    build = (vim.fn.has("win32") == 1)
        and ((vim.o.shell:match("bash$") or vim.o.shell:match("bash%.exe$")) and jsregexp_build_command or 'C:\\msys64\\usr\\bin\\env.exe CHERE_INVOKING=1 MSYSTEM=UCRT64 C:\\msys64\\usr\\bin\\bash.exe -l -c "' .. jsregexp_build_command .. '"')
      or jsregexp_build_command,
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
