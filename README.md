- This is currently used with `NVIM v0.12`.
- This is a LazyVim-based configuration. I plan on "lean"ify-ing it in the future...
- Yes, I have very non-standard keybinds
- This was initially iterated on a Windows machine so some settings are Windows & MSYS2 specific (but is now mainly used on Linux)
- Plugin git operations use SSH (targeted at GitHub's system) due to 1) better firewall circumvention 2) ease of using plugins with private repos.
  - You might have to use `local use_ssh = false` in [lua/config/lazy.lua:9](lua/config/lazy.lua) if you do not have SSH set up. (Or `lazy.nvim` will fail horribly on startup)
- I mostly do _not_ use mason but rather system-wide LSP/tool installations.

Some me-specific things that you might want to change:

- keybinds ([lua/config/keymaps.lua](lua/config/keymaps.lua) as well as key mappings in various plugin configs)
- hardcoding of paths and my own username in `lazy`'s `dev` option in [lua/config/lazy.lua:41](lua/config/lazy.lua)
- `blink.cmp` being on main... (requires you to have a rust toolchain, so you might want to just use release versions)
