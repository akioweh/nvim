# Test harness (mini.test), mirroring the grug-far fork.
#
#   make prepare            # one-time: fetch deps/mini.nvim
#   make test               # run the whole suite (unit + integration)
#   make test-unit          # only tests/unit/**
#   make test-integration   # only tests/integration/**
#   make test file=unit/test_platform.lua   # a single file
#   make update-screenshots # regenerate all reference screenshots
#   make lint               # stylua --check
#
# Override the Neovim binary with nvim_path=... (pin it when updating
# screenshots so references stay stable, e.g. nvim_path=~/.local/bin/nvim-0.12).

nvim_path ?= nvim
MINIT := --headless --noplugin -u ./scripts/minimal_init.lua -l ./scripts/test_cli.lua

# Default suite: fast, reliable unit tests (no child processes, no network).
test: test-unit

test-unit:
	dir=unit $(nvim_path) $(MINIT)

# Heavy: spawn child Neovims running the REAL config (needs plugins installed).
# The test children disable lazy's update checker + Mason auto-install, so this
# runs offline. (Spawning a child needs OS permission to create a --listen
# socket, which some sandboxes block.)
test-integration:
	dir=integration $(nvim_path) $(MINIT)

# Everything (unit + integration).
test-all:
	$(nvim_path) $(MINIT)

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

.PHONY: test test-unit test-integration test-all update-screenshots prepare lint clean
