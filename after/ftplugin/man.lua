-- default ftplugin maps j->gj and k->gk and conflicts with our custom mappings
vim.keymap.del("n", "j", { buffer = true })
vim.keymap.del("n", "k", { buffer = true })
