-- Keymaps are automatically loaded on the VeryLazy event.
-- LazyVim's defaults are in lazyvim/config/keymaps.lua; these are my additions.

-- Escape to save, carried over from my old config.
--
-- Two fixes over the plain `:w<CR>` I had before:
--   1. it still clears search highlighting, which is what LazyVim binds <Esc>
--      to by default and what I would otherwise have lost;
--   2. it only writes real, modified, named files. The old mapping threw
--      "E32: No file name" or "E45: readonly" whenever I hit <Esc> inside
--      Oil, :Lazy, a help buffer or a diff view.
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch")
  local buf = vim.api.nvim_get_current_buf()
  local writable = vim.bo[buf].buftype == ""
    and vim.bo[buf].modifiable
    and not vim.bo[buf].readonly
    and vim.api.nvim_buf_get_name(buf) ~= ""
  if writable and vim.bo[buf].modified then
    vim.cmd("silent write")
  end
end, { desc = "Clear Search & Save" })

-- Pasting over a visual selection no longer clobbers the unnamed register,
-- so I can paste the same thing repeatedly.
vim.keymap.set("x", "p", function()
  return "pgv\"" .. vim.v.register .. "y"
end, { expr = true, desc = "Paste Without Yanking" })
