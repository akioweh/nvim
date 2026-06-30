local platform = require("util.platform")
local jsregexp_build_command = "make install_jsregexp LUA_LDLIBS='-lluajit-5.1'" -- link against luajit instead of lua

--- jsregexp is optional; resolve a build command per environment, or nil to skip
--- the build cleanly when no toolchain is reachable.
---@return string?
local function jsregexp_build()
  if platform.is_unix then
    return jsregexp_build_command -- linux or msys2: native make
  elseif platform.has_msys2 then
    return platform.msys2_wrap(jsregexp_build_command) -- native windows: shell out to msys2
  end
  return nil -- native windows without msys2: skip optional build
end

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
    build = jsregexp_build(),
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
