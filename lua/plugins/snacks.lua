---@return snacks.toggle.Class
local function create_vld_toggle()
  local cached = {}
  return require("snacks").toggle({
    name = "Virtual Line Diagnostics",
    get = function()
      local config = vim.diagnostic.config() or {}
      return config.virtual_lines ~= false
    end,
    set = function(state)
      local config = vim.diagnostic.config() or {}

      local show = state and "virtual_lines" or "virtual_text"
      local hide = state and "virtual_text" or "virtual_lines"
      local previous = config[hide]
      if previous then
        cached[hide] = type(previous) == "function" and previous or function()
          return previous
        end
      end
      config[show] = cached[show] or true
      config[hide] = false

      vim.diagnostic.config(config)
    end,
  })
end

---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        -- stylua: ignore
        callback = function()
          LazyVim.format.snacks_toggle():map("<leader>uf", { silent = true })
          LazyVim.format.snacks_toggle(true):map("<leader>uF", { silent = true })
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us", { silent = true })
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw", { silent = true })
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL", { silent = true })
          Snacks.toggle.diagnostics():map("<leader>ud", { silent = true })
          Snacks.toggle.line_number():map("<leader>ul", { silent = true })
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc", { silent = true })
          Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA", { silent = true })
          Snacks.toggle.treesitter():map("<leader>uT", { silent = true })
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub", { silent = true })
          Snacks.toggle.dim():map("<leader>uD", { silent = true })
          Snacks.toggle.animate():map("<leader>ua", { silent = true })
          Snacks.toggle.indent():map("<leader>ug", { silent = true })
          Snacks.toggle.scroll():map("<leader>uS", { silent = true })
          Snacks.toggle.profiler():map("<leader>dpp", { silent = true })
          Snacks.toggle.profiler_highlights():map("<leader>dph", { silent = true })
          Snacks.toggle.inlay_hints():map("<leader>uh", { silent = true })
          Snacks.toggle.zoom():map("<leader>wm", { silent = true }):map("<leader>uZ", { silent = true })
          Snacks.toggle.zen():map("<leader>uz", { silent = true })
          create_vld_toggle():map("<leader>uv")
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      -- Buffers
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", silent = true },
      { "<leader>bo", function() local tab_buflist = vim.fn.tabpagebuflist() Snacks.bufdelete(function(buf) return not vim.list_contains(tab_buflist, buf) end) end, desc = "Delete Buffers other than the current layout", silent = true },
      { "<leader>bO", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers", silent = true },
      { "<leader>bi", function() Snacks.bufdelete.invisible() end, desc = "Delete Invisible Buffers", silent = true },

      -- Git
      { "<leader>gg", vim.fn.executable("lazygit") == 1 and function() Snacks.lazygit({ cwd = LazyVim.root.git() }) end or false, desc = "Lazygit (Root Dir)", silent = true },
      { "<leader>gG", vim.fn.executable("lazygit") == 1 and function() Snacks.lazygit() end or false, desc = "Lazygit (cwd)", silent = true },
      { "<leader>gL", function() Snacks.picker.git_log() end, desc = "Git Log (cwd)", silent = true },
      { "<leader>gb", function() Snacks.picker.git_log_line() end, desc = "Git Blame Line", silent = true },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Current File History", silent = true },
      { "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, desc = "Git Log", silent = true },
      { "<leader>gB", function() Snacks.gitbrowse() end, mode = { "n", "x" }, desc = "Git Browse (open)", silent = true },
      { "<leader>gY", function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false }) end, mode = { "n", "x" }, desc = "Git Browse (copy)", silent = true },

      -- Terminal
      { "<leader>fT", function() Snacks.terminal() end, desc = "Terminal (cwd)", silent = true },
      { "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, desc = "Terminal (Root Dir)", silent = true },
      { "<c-/>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end, mode = { "n", "t" }, desc = "Terminal (Root Dir)", silent = true },
      { "<c-_>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end, mode = { "n", "t" }, desc = "which_key_ignore", silent = true },

      -- Lua
      { "<localleader>r", function() Snacks.debug.run() end, mode = { "n", "x" }, desc = "Run Lua", ft = "lua", silent = true },
    },
    ---@type snacks.Config
    opts = {
      animate = { enabled = false }, -- how dare you try animate a TUI >:(
      scroll = { enabled = false }, -- smooth scrolling
      dashboard = { enabled = false },
      input = { enabled = false },
      words = {
        enabled = false,
        -- debounce = 25,
        -- modes = { "n", "c" },
      },
      image = {
        enabled = true,
        math = { enabled = false },
      },
      styles = {
        -- fullscreen lazygit
        lazygit = {
          width = 0,
          height = 0,
          border = false,
          backdrop = false,
        },
      },
    },
  },
}
