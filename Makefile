# Test harness (mini.test), mirroring the grug-far fork.
#
#   make prepare            # one-time: fetch deps/mini.nvim
#   make test               # run the whole suite (unit + integration)
#   make test-unit          # only tests/unit/**
#   make test-integration   # only tests/integration/** (needs `make restore` first)
#   make test file=unit/test_platform.lua   # a single file
#   make restore            # install plugins from the lockfile into the data dir
#   make test-install       # clean-install smoke: lazy installs from scratch
#   make update-screenshots # regenerate all reference screenshots
#   make lint               # stylua --check
#
# Override the Neovim binary with nvim_path=... (pin it when updating
# screenshots so references stay stable, e.g. nvim_path=~/.local/bin/nvim-0.12).

# ---------------------------------------------------------------------------
# Load THIS directory as the Neovim config, wherever it lives (worktree at
# ~/.config/nvim-dev, a CI checkout at $GITHUB_WORKSPACE, a plain clone, ...).
#
# Neovim resolves its config from stdpath("config") = $XDG_CONFIG_HOME/$NVIM_APPNAME,
# and lazy.nvim RESETS 'runtimepath' to stdpath("config") during setup — so a bare
# `nvim --cmd "set rtp^=$PWD" -u init.lua` is silently undone and the WRONG config
# (whatever lives at ~/.config/nvim) loads instead. The only robust fix is to make
# stdpath("config") itself equal this directory:
#     XDG_CONFIG_HOME = parent(CURDIR),  NVIM_APPNAME = basename(CURDIR)
# This also scopes data/state/cache under the same appname (clean & isolated).
# Locally (CURDIR=~/.config/nvim-dev) XDG_CONFIG_HOME resolves to the usual
# ~/.config, so it is a no-op there; on CI it points at the checkout's parent.
# ---------------------------------------------------------------------------
export NVIM_APPNAME := $(notdir $(CURDIR))
export XDG_CONFIG_HOME := $(patsubst %/,%,$(dir $(CURDIR)))

nvim_path ?= nvim
MINIT := --headless --noplugin -u ./scripts/minimal_init.lua -l ./scripts/test_cli.lua

# Default suite: fast, reliable unit tests (no child processes, no network).
test: test-unit

test-unit:
	dir=unit $(nvim_path) $(MINIT)

# Heavy: spawn child Neovims running the REAL config (needs plugins installed —
# run `make restore` first). The test children disable lazy's update checker +
# Mason auto-install, so this runs offline. (Spawning a child needs OS permission
# to create a --listen socket, which some sandboxes block.)
test-integration:
	dir=integration $(nvim_path) $(MINIT)

# Everything (unit + integration).
test-all:
	$(nvim_path) $(MINIT)

# Install/restore every plugin into this config's (appname-scoped) data dir from
# the committed lockfile, so the integration children can load them off disk.
# Offline-safe (checker + Mason auto-install disabled). CI warm-up + local first run.
restore:
	NVIM_NO_AUTO_INSTALL=1 $(nvim_path) --headless --cmd "let g:auto_update = v:false" "+Lazy! restore" "+qa"

# Clean-install smoke: prove `lazy` can install EVERYTHING from scratch (all the
# git clones) into a pristine data dir, and that the config then loads with every
# plugin on disk. Slow + online, so it is a SEPARATE target — deliberately NOT part
# of `test`/`test-unit` (re-cloning between every test would be unbearable). Uses
# throwaway XDG data/state/cache under .tests/ (gitignored); config stays this repo.
clean_data := $(CURDIR)/.tests/clean
clean_xdg := XDG_DATA_HOME=$(clean_data)/share XDG_STATE_HOME=$(clean_data)/state XDG_CACHE_HOME=$(clean_data)/cache
test-install:
	rm -rf $(clean_data)
	NVIM_NO_AUTO_INSTALL=1 $(clean_xdg) $(nvim_path) --headless --cmd "let g:auto_update = v:false" "+Lazy! install" "+qa"
	NVIM_NO_AUTO_INSTALL=1 $(clean_xdg) $(nvim_path) --headless -c "luafile scripts/assert_install.lua" "+qa"

# Regenerate every reference screenshot: delete them, then an integration run
# writes them fresh (reference_screenshot writes when the file is missing).
update-screenshots:
	rm -rf tests/screenshots/*
	$(MAKE) test-integration

# Vendored mini.nvim (pinned). deps/ is gitignored.
deps/mini.nvim:
	@mkdir -p deps
	git clone --depth=1 --branch=v0.15.0 https://github.com/echasnovski/mini.nvim deps/mini.nvim

prepare: | deps/mini.nvim

lint:
	stylua --check lua tests

clean:
	rm -rf deps .tests

.PHONY: test test-unit test-integration test-all restore test-install update-screenshots prepare lint clean
