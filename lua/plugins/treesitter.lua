return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- make treesitter download/install using git + ssh
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.install").compilers = { "gcc" }
      local parsers = require("nvim-treesitter.parsers").get_parser_configs()
      for _, p in pairs(parsers) do
        if p.install_info and p.install_info.url then
          p.install_info.url = p.install_info.url:gsub("https://github.com/", "git@github.com:")
        end
      end
      -- W keybinds
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "e",
          node_incremental = "e",
          scope_incremental = false,
          node_decremental = "E",
        },
      }
      -- opts.auto_install = true
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "latex")

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.disable = opts.highlight.disable or {}
      if not vim.tbl_contains(opts.highlight.disable, "latex") then
        table.insert(opts.highlight.disable, "latex")
      end
      opts.highlight.additional_vim_regex_highlighting = { "latex", "markdown" }
    end,
  },
}
