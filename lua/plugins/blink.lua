if false then
  require("colorful-menu")
end

---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    dependencies = { "rafamadriz/friendly-snippets", "xzbdmw/colorful-menu.nvim" },
    init = function()
      vim.treesitter.language.register("markdown", {
        "blink-cmp-documentation",
        "blink-cmp-signature",
      })
      -- wtf is this i hate it
      vim.api.nvim_create_autocmd({ "WinNew", "BufWinEnter" }, {
        callback = function()
          local win = vim.fn.win_getid() -- current window
          if not vim.api.nvim_win_is_valid(win) then
            return
          end

          -- Only floats
          local cfg = vim.api.nvim_win_get_config(win)
          if not cfg or cfg.relative == "" then
            return
          end

          -- Check blink signature winhighlight
          local wh = vim.wo[win].winhighlight or ""
          if not string.find(wh, "BlinkCmpSignatureHelp") then
            return
          end

          local bufnr = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.bo[bufnr].filetype = "markdown"
          end
        end,
      })
    end,
    ---@param opts blink.cmp.Config
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.nerd_font_variant = "normal"
      -- override lazyvim stuff
      opts.keymap = {
        preset = "super-tab",
        ["<C-b>"] = { "scroll_documentation_up", "scroll_signature_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "scroll_signature_down", "fallback" },
        ["<M-h>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-k>"] = {},
      }
      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = {
        auto_insert = true,
        preselect = function()
          return not require("blink.cmp").snippet_active({ direction = 1 })
        end,
      }
      opts.completion.menu = {
        draw = {
          -- We don't need label_description now because label and label_description are already
          -- combined together in label by colorful-menu.nvim.
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            label = {
              text = require("colorful-menu").blink_components_text,
              highlight = require("colorful-menu").blink_components_highlight,
            },
          },
        },
      }
      opts.completion.documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = {
          max_width = 120,
        },
        draw = function(_opts)
          _opts.default_implementation()

          local bufnr = _opts.window.buf
          if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end

          -- -- If the LSP sent Markdown, mark the buffer so render-markdown will style it
          -- local doc = _opts.item and _opts.item.documentation
          -- local kind = nil
          -- if type(doc) == "table" then
          --   -- LSP MarkupContent has .kind = 'markdown' | 'plaintext'
          --   kind = doc.kind
          -- elseif type(doc) == "string" then
          --   -- blink treats a raw string as plaintext
          --   kind = "plaintext"
          -- end
          --
          -- if kind == "markdown" then
          --   vim.bo[bufnr].filetype = "markdown"
          -- else
          --   -- Optional: use plaintext to avoid accidental markdown rules on non-markdown docs
          --   vim.bo[bufnr].filetype = "text"
          -- end

          -- ...nah, always markdown :)
          vim.bo[bufnr].filetype = "markdown"
        end,
      }
      opts.signature = {
        enabled = true,
        trigger = {
          show_on_keyword = true,
          show_on_insert = true,
        },
        window = {
          show_documentation = true,
        },
      }
      opts.cmdline = {
        enabled = true,
      }
      opts.term = {
        enabled = true,
      }
    end,
  },
  {
    "folke/noice.nvim",
    opts = { -- stop duplicated signature helps
      lsp = {
        signature = {
          enabled = false,
        },
        hover = { -- i like render-markdown (default) better
          enabled = false,
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      completions = {
        blink = {
          enabled = true,
        },
      },
    },
  },
  {
    "xzbdmw/colorful-menu.nvim",
    optional = true,
    ---@type ColorfulMenuConfig
    opts = {
      ls = {
        lua_ls = {
          -- Maybe you want to dim arguments a bit.
          arguments_hl = "@comment",
        },
        gopls = {
          align_type_to_right = true,
          -- only has an effect when NOT right aligned
          add_colon_before_type = false,
          -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
          preserve_type_when_truncate = true,
        },
        -- for lsp_config or typescript-tools
        ts_ls = {
          -- false means do not include any extra info,
          -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
          extra_info_hl = "@comment",
        },
        vtsls = {
          -- false means do not include any extra info,
          -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
          extra_info_hl = "@comment",
        },
        ["rust-analyzer"] = {
          -- Such as (as Iterator), (use std::io).
          extra_info_hl = "@comment",
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
          -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
          preserve_type_when_truncate = true,
        },
        clangd = {
          -- Such as "From <stdio.h>".
          extra_info_hl = "@comment",
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
          -- the hl group of leading dot of "•std::filesystem::permissions(..)"
          import_dot_hl = "@comment",
          -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
          preserve_type_when_truncate = true,
        },
        zls = {
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
        },
        roslyn = {
          extra_info_hl = "@comment",
        },
        dartls = {
          extra_info_hl = "@comment",
        },
        -- The same applies to pyright/pylance
        basedpyright = {
          -- It is usually import path such as "os"
          extra_info_hl = "@comment",
        },
        pylsp = {
          extra_info_hl = "@comment",
          -- Dim the function argument area, which is the main
          -- difference with pyright.
          arguments_hl = "@comment",
        },
        -- If true, try to highlight "not supported" languages.
        fallback = true,
        -- this will be applied to label description for unsupport languages
        fallback_extra_info_hl = "@comment",
      },
      -- If the built-in logic fails to find a suitable highlight group for a label,
      -- this highlight is applied to the label.
      fallback_highlight = "@variable",
      -- If provided, the plugin truncates the final displayed text to
      -- this width (measured in display cells). Any highlights that extend
      -- beyond the truncation point are ignored. When set to a float
      -- between 0 and 1, it'll be treated as percentage of the width of
      -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
      -- Default 60.
      -- max_width = 0.8,
    },
  },
}
