-- Autocmds are automatically loaded on the VeryLazy event.
-- LazyVim's defaults are in lazyvim/config/autocmds.lua; these are my additions.

local augroup = vim.api.nvim_create_augroup("user_indent", { clear = true })

-- LazyVim defaults to 2 spaces everywhere. C and Python both conventionally
-- use 4, and getting this wrong shows up immediately in diffs. An .editorconfig
-- in the project still wins, since nvim's builtin editorconfig support runs
-- on BufNewFile/BufReadPost and applies after this.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp", "python" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

-- Go is gofmt's business: real tabs, and gofumpt will not accept anything else.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "go", "gomod", "gowork" },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

-- Warn instead of silently editing a read-only nix store path. This happens
-- constantly when following gd/gr into a plugin or a library that home-manager
-- installed, and the resulting E45 on write is easy to misread as a real bug.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("user_nix_store", { clear = true }),
  callback = function(ev)
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name:match("^/nix/store/") then
      vim.bo[ev.buf].modifiable = false
      vim.bo[ev.buf].readonly = true
    end
  end,
})
