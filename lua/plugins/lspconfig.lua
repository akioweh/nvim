return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
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
          mason = false,
        },
        basedpyright = {
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
          init_options = {
            settings = {
              lint = {
                enable = false,
              },
            },
          },
          mason = false,
        },
      },
    },
  },
}
