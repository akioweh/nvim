-- why tf lazyvim hardcode paths???
return {
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup("py")
    end,
  },
}
