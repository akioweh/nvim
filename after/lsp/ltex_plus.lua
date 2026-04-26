---@type vim.lsp.Config
return {
  settings = {
    cmd_env = {
      JAVA_OPTS = "-Xmx2g -XX:+UseZGC -XX:+ZGenerational -Xms32m -Xmx3g -XX:ZUncommitDelay=30",
    },
    ltex = {
      languageToolHttpServerUri = "http://localhost:8081/",
    },
  },
}
