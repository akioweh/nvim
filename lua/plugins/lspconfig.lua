---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          mason = false,
        },
        hls = {
          mason = false,
        },
        pyright = {
          enabled = false,
          mason = false,
        },
        basedpyright = {
          enabled = false,
          settings = {
            basedpyright = {
              analysis = {
                inlayHints = {
                  genericTypes = true,
                },
              },
            },
          },
          mason = false,
        },
        ruff = {
          enabled = false,
          init_options = {
            settings = {
              lint = {
                enable = false,
              },
            },
          },
          mason = false,
        },
        pylsp = {
          enabled = true,
          settings = {
            pylsp = {
              -- rope = {
              --   ropeFolder = { ".ropeproject" },
              -- },
              plugins = {
                autopep8 = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                yapf = { enabled = false },
                ruff = {
                  enabled = true,
                  config = "~/.config/ruff/ruff.toml",
                  formatEnabled = true,
                },
                -- rope_autoimport = { enabled = true },
                rope_completion = { enabled = true },
                jedi_rename = { enabled = true },
                jedi_completion = { enabled = false, fuzzy = true },
                pylsp_mypy = { enabled = true },
                pylsp_rope = { rename = false },
              },
            },
          },
          mason = false,
        },
        tinymist = {
          mason = false,
        },
        lua_ls = {
          mason = false,
        },
      },
    },
  },
}
