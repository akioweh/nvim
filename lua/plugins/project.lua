---@type LazySpec
return {
  {
    "DrKJeff16/project.nvim",
    init = function()
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("projects")
      end)
    end,
    cmd = {
      "Project",
      "ProjectAdd",
      "ProjectConfig",
      "ProjectDelete",
      "ProjectHistory",
      "ProjectRecents",
      "ProjectRoot",
      "ProjectSession",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    keys = {
      {
        "<leader>fp",
        function()
          vim.cmd("Telescope projects")
        end,
        desc = "Projects",
      },
    },
  },
}
