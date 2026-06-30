---@type LazySpec
return {
  {
    "anurag3301/nvim-platformio.lua",
    -- cmd = { "Pioinit", "Piorun", "Piocmdh", "Piocmdf", "Piolib", "Piomon", "Piodebug", "Piodb" },
    -- Satellite feature: opt in per machine with vim.g.enable_platformio = true
    -- (config/local.lua). Off by default (not installed); when on, `cond` below
    -- still gates loading on a platformio.ini in the cwd. Read at spec-build time
    -- (like plugins/vscode.lua), so set the flag before lazy.setup.
    enabled = vim.g.enable_platformio == true,
    -- optional: cond used to enable/disable platformio
    -- based on existance of platformio.ini file and .pio folder in cwd.
    -- You can enable platformio plugin, using :Pioinit command
    cond = function()
      local platformioRootDir = vim.fs.root(vim.fn.getcwd(), { "platformio.ini" }) -- cwd and parents
      -- local platformioRootDir = (vim.fn.filereadable("platformio.ini") == 1) and vim.fn.getcwd() or nil
      if platformioRootDir then
        -- if platformio.ini file exist in cwd, enable plugin to install plugin (if not istalled) and load it.
        vim.g.platformioRootDir = platformioRootDir
      elseif vim.uv.fs_stat(vim.fn.stdpath("data") .. "/lazy/nvim-platformio.lua") == nil then
        -- if nvim-platformio not installed, enable plugin to install it first time
        vim.g.platformioRootDir = vim.fn.getcwd()
      else -- if nvim-platformio.lua installed but disabled, create Pioinit command
        vim.api.nvim_create_user_command("Pioinit", function() --available only if no platformio.ini and .pio in cwd
          vim.api.nvim_create_autocmd("User", {
            pattern = { "LazyRestore", "LazyLoad" },
            once = true,
            callback = function(args)
              if args.match == "LazyRestore" then
                require("lazy").load({ plugins = { "nvim-platformio.lua" } })
              elseif args.match == "LazyLoad" then
                local pio_install_status = require("platformio.utils").pio_install_check()
                if not pio_install_status then
                  return
                end
                vim.notify("PlatformIO loaded", vim.log.levels.INFO, { title = "PlatformIO" })
                require("platformio").setup(vim.g.pioConfig)
                vim.cmd("Pioinit")
              end
            end,
          })
          vim.g.platformioRootDir = vim.fn.getcwd()
          require("lazy").restore({ plguins = { "nvim-platformio.lua" }, show = false })
        end, {})
      end
      return vim.g.platformioRootDir ~= nil
    end,

    dependencies = {
      { "akinsho/toggleterm.nvim" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "folke/which-key.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },

    opts = {
      lsp = "clangd",
      clangd_source = "ccls",
      menu_key = "<leader>\\",
    },
  },
}
