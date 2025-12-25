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
        preset = "none",
        ["<C-j>"] = { "show", "show_documentation", "hide_documentation", "fallback_to_mappings" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Tab>"] = { "accept", "snippet_forward", vim.lsp.inline_completion.get, "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "scroll_signature_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "scroll_signature_down", "fallback" },
        ["<M-h>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-y>"] = { vim.lsp.inline_completion.get, "fallback_to_mappings" },
      }
      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = {
        auto_insert = true,
        preselect = function() -- do not preselect if snippet is active
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

          -- If the LSP sent Markdown, override the buftype so render-markdown will style it
          local doc = _opts.item and _opts.item.documentation
          local kind = "unknown"
          if type(doc) == "table" then
            kind = doc.kind
          end
          if kind == "markdown" then
            vim.bo[bufnr].filetype = "markdown"
          end
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
    end,
    ---@param opts blink.cmp.Config
    config = function(_, opts)
      -- setup nvim-cmp compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end
      -- Unset custom prop to pass blink.cmp validation
      ---@diagnostic disable-next-line: inject-field
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
              item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
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
