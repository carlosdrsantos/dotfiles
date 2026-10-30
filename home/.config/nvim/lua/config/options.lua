-- Options added here are loaded before lazy.nvim starts, on top of
-- LazyVim's own defaults in lazyvim/config/options.lua.
-- Only the deltas from LazyVim live here, so it stays obvious what I changed.

-- ── LazyVim feature switches ────────────────────────────────────────────────
-- basedpyright over pyright: same engine, but it actually implements the
-- stricter inference modes and reports unreachable/unused code. ruff stays
-- in charge of linting and import sorting so the two do not double-report.
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- ── editor deltas ───────────────────────────────────────────────────────────
local opt = vim.opt

opt.scrolloff = 16          -- LazyVim ships 4; I like the cursor well clear of the edge
opt.relativenumber = true   -- relative line numbers for fast d3j style jumps
opt.wrap = false
opt.splitkeep = "screen"    -- opening a split does not scroll the window I was reading

-- Nix builds are read-only, so writing to a store path is always a mistake.
-- LazyVim has no opinion here; this makes the failure obvious rather than cryptic.
opt.backup = false
opt.writebackup = false
