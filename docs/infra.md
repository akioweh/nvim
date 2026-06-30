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

Pattern (see `plugins/platformio.lua`, `plugins/vscode.lua`): gate the spec with a
boolean read **at spec-build time** — `enabled = vim.g.enable_<x> == true`. Set the
flag in `local.lua` (before `lazy.setup`); an `enabled = function()…end` is *not*
re-evaluated reliably, so use the boolean form.

## vscode-neovim

`plugins/vscode.lua`: under `vim.g.vscode`, merge-disables heavy-UI plugins by name
(snacks is kept but soft-configured). One auditable list.

## Tests (`tests/`, mini.test)

| target | what |
|--------|------|
| `make test` | unit only — fast, offline, no child processes (default) |
| `make test-integration` | child Neovims load the real config: vscode gating + screenshots |
| `make test-all` | both |
| `make update-screenshots` | regenerate `tests/screenshots/` (commit after) |
| `make lint` | `stylua --check` |
| `make prepare` | clone `deps/mini.nvim` (pinned; gitignored) |

- `tests/unit/*` — pure modules via the `_detect` seam (mock env). Run anywhere.
- `tests/integration/*` — spawn a child running the **real** config (`--clean` +
  `set rtp^=cwd` + `-u init.lua`). The child sets `g:auto_update=false` and
  `NVIM_NO_AUTO_INSTALL=1`, so it loads fully offline. It does need OS permission to
  create a `--listen` socket (some sandboxes block that).
- Screenshots are nvim-version specific → CI pins the version; baselines are
  committed in `tests/screenshots/`.
- CI: `.github/workflows/tests.yml` — Linux unit + integration, Windows unit-only.
