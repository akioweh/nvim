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
      "akioweh/lsp-document-highlight.nvim",
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
        ReferenceWrite = { text = { "─", "═" }, priority = 10, highlight = "LspReferenceWriteMark" },
        ReferenceRead = { text = { "─", "═" }, priority = 9, highlight = "LspReferenceReadMark" },
        ReferenceText = { text = { "─", "═" }, priority = 8, highlight = "LspReferenceTextMark" },
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

      --- integration with lsp-document-highlight.nvim: document highlight marks provider ---

      local function collect_references(bufnr)
        local marks = {} ---@type ScrollbarMark[]
        local seen = {} ---@type table<string, boolean>
        local types = { "ReferenceText", "ReferenceRead", "ReferenceWrite" }
        for _, ref in ipairs(require("lsp-document-highlight").get_highlights(bufnr)) do
          local line = ref.l[1] - 1
          local key = line .. ":" .. ref.kind
          if not seen[key] then
            seen[key] = true
            marks[#marks + 1] = { line = line, type = types[ref.kind] }
          end
        end
        return marks
      end

      local providers = require("scrollbar.providers")
      providers.unregister("document_highlight")
      ---@type ScrollbarProvider
      local provider = {
        name = "document_highlight",
        setup = function(context)
          ---@param args vim.api.keyset.create_autocmd.callback_args
          local function update(args)
            local bufnr = args.event == "User" and args.data.bufnr or args.buf
            if context.is_buffer_eligible(bufnr) then
              context.set_marks(bufnr, collect_references(bufnr))
            else
              context.clear_marks(bufnr)
            end
          end

          local group = context.create_augroup("updates")
          vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = "LspDocumentHighlightChanged",
            callback = update,
          })
          -- TextChanged* can move lines; buffer switching needs re-initialization (LDH may not send update if highlights are cached)
          vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "TextChangedP" }, {
            group = group,
            callback = update,
          })
        end,
      }
      providers.register(provider)

      require("scrollbar").setup(opts)

      set_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("scrollbar_transparency", { clear = true }),
        callback = set_highlights,
      })
    end,
  },
}
