# Infrastructure notes

Key notes on the custom machinery added on the `windows` branch. Terse by design.

## `lua/util/` — environment & tooling

Pure, LazyVim-free modules (no side effects on require beyond `tools`'s `:ToolForce`
command), so they're safe to `require` even from `config/lazy.lua` before LazyVim
loads.

### `util.platform` — single source of truth for the environment

- `env` — `"linux" | "windows" | "msys2"` (**mac is out of scope**). `"windows"` =
  native; `"msys2"` = running *inside* an MSYS2 shell (unix-like). Both can exist on
  one machine; which is live depends on how nvim launched.
- Booleans: `is_linux`, `is_windows` (native only), `is_msys2`, `is_win_os`
  (`= is_windows or is_msys2`), `is_unix` (`= is_linux or is_msys2`), `is_vscode`.
- Capability (orthogonal to `env`): `has_msys2`, `msys2_root` — an *invokable* MSYS2
  install even from native Windows (validated by `usr/bin/{bash,pacman}.exe`).
- Also: `shell{path,kind,is_msys_bash}`, `sep`, `exe_suffix`, `executable(bin)`,
  `msys2_wrap(cmd)`, `dev_path`, `basename(path)`, `refresh()`.
- Detection is `M._detect(inputs)` — a pure function of injected inputs, so the
  whole matrix is unit-tested on Linux. `refresh()` re-runs it (options.lua calls
  it after it may mutate `vim.o.shell`).

### `util.tools` — system-first vs Mason

- `vim.g.tools_strategy`: `"smart"` (default — use a system install if on PATH,
  else Mason) or `"mason"` (Mason manages everything).
- `tools.use_mason(key)` is the single chokepoint used by `plugins/{mason,lspconfig,
  mason-nvim-dap}.lua`.
- Per-tool override file (machine-local JSON, **not committed**):
  `stdpath("state")/nvim-tool-overrides.json`, `{ force = { ty = "mason" }, ... }`.
  Edit it or use `:ToolForce <tool> [mason|system]` (no value clears; no args
  prints current state).
- `NVIM_NO_AUTO_INSTALL=1` → `use_mason` always false (never install; treat all as
  system). Used by the offline integration tests.

### `util.context` — feature-gating predicates

Builders returning `fun():boolean` for lazy `enabled`/`cond`: `not_vscode()`,
`on_env(...)`, `if_executable(bin)`, `if_root(markers)`, `has_tool(key)`. Staged
infrastructure — wire into specs as needed.

## Machine-local config & toggles

`lua/config/local.lua` (gitignored; copy from `local.lua.example`) is loaded first
in `lazy.lua`, before anything reads these. Set in it:

| flag | default | effect |
|------|---------|--------|
| `vim.g.use_ssh` | `false` | git over ssh (else https — avoids ssh-agent hangs) |
| `vim.g.auto_update` | `true` | lazy's periodic update check (network) |
| `vim.g.tools_strategy` | `"smart"` | `"smart"` or `"mason"` |
| `vim.g.enable_platformio` | `false` | opt in the platformio satellite |
| `vim.env.NVIM_DEV_PATH` | — | local `dev` plugin dir (overrides `K:`/`~`) |
| `vim.env.NVIM_MSYS2_ROOT` | — | explicit MSYS2 root |
| `vim.env.NVIM_NO_AUTO_INSTALL` | — | `"1"` disables all Mason auto-install |

## Satellite feature toggles

Pattern (see `plugins/platformio.lua`): gate the spec with a boolean read **at
spec-build time** — `enabled = vim.g.enable_<x> == true`. Set the flag in
`local.lua` (before `lazy.setup`); an `enabled = function()…end` is *not*
re-evaluated reliably, so use the boolean form.

## vscode-neovim

LazyVim **auto-loads** its `extras.vscode` whenever `vim.g.vscode` is set — it
inserts the extra at `extras[1]` in `lazyvim/plugins/xtras.lua`, so it is NOT in
`lazyvim.json` yet still runs. That extra sets `Config.options.defaults.cond` to a
whitelist of editing-essential plugins (everything else is gated off; VSCode owns
the UI) — **but it `require("vscode")`s the vscode-neovim runtime module at load,
which doesn't exist under headless Neovim**, so the extra errors before setting its
`cond` and is a silent no-op in tests/CI.

`plugins/vscode.lua` is therefore our **self-contained** handler (crucially, no
`require("vscode")`): imported *after* `lazyvim.plugins`, its
`Config.options.defaults.cond` **overrides** the extra's with a config-tailored
whitelist (adds `ultimate-autopair.nvim` — we use it, not mini.pairs — plus
mini.ai/surround/move/comment, yanky, dial, treesitter + textobjects, snacks). This
is deliberate: it makes the vscode profile work AND be testable headless. **Do not
slim it to `vscode = true` markers + delegate to the extra** — that drops all gating
under headless CI (verified). Add a plugin back by listing it here or setting
`vscode = true` on its spec. Buffer-cycle keys `<M-j>`/`<M-l>` map to VSCode editor
tabs (keymaps.lua).

## Tests (`tests/`, mini.test)

| target | what |
|--------|------|
| `make test` | unit only — fast, offline, no child processes (default) |
| `make restore` | install plugins from the lockfile into the data dir (integration warm-up) |
| `make test-integration` | child Neovims load the real config: vscode gating + screenshots |
| `make test-all` | unit + integration |
| `make test-install` | clean-install smoke: lazy installs from scratch into a fresh data dir |
| `make update-screenshots` | regenerate `tests/screenshots/` (commit after) |
| `make lint` | `stylua --check` |
| `make prepare` | clone `deps/mini.nvim` (pinned; gitignored) |

**Loading the right config (critical).** Neovim reads its config from
`stdpath("config") = $XDG_CONFIG_HOME/$NVIM_APPNAME`, and lazy **resets `rtp` to
`stdpath("config")`** on setup — so `nvim --cmd "set rtp^=$PWD" -u init.lua` is
silently undone and loads whatever lives at `~/.config/nvim` instead of this repo.
The Makefile fixes this at the source: it exports `NVIM_APPNAME = basename(CURDIR)`
and `XDG_CONFIG_HOME = parent(CURDIR)` so `stdpath("config")` **is** this directory
(and data/state/cache are scoped under that appname). Works identically for the
`~/.config/nvim-dev` worktree and a CI checkout at `$GITHUB_WORKSPACE`. Locally that
means `NVIM_APPNAME=nvim-dev nvim` opens this config against an isolated data dir.

- `tests/unit/*` — pure modules via the `_detect` seam (mock env). Run anywhere.
- `tests/integration/*` — spawn a child running the **real** config (needs plugins
  installed → `make restore` first). The child sets `g:auto_update=false` and
  `NVIM_NO_AUTO_INSTALL=1`, so it loads fully offline. It does need OS permission to
  create a `--listen` socket (some sandboxes block that).
- `make test-install` — proves lazy can clone the whole plugin set into a pristine
  data dir, then asserts every plugin is on disk (`scripts/assert_install.lua`).
  Slow + online, so it is a **separate** target/job, never part of `make test`.
- Screenshots are nvim-version specific → CI pins the version; baselines are
  committed in `tests/screenshots/`.
- CI: `.github/workflows/tests.yml` — jobs: `unit`, `integration` (`make restore` →
  `make test-integration`), `clean-install` (`make test-install`), `windows-unit`.
