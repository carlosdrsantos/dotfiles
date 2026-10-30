-- The neovim half of the C-hjkl navigation set up in ../../tmux/tmux.conf.
--
-- LazyVim already maps C-hjkl to <C-w>h/j/k/l, which moves between neovim's
-- own splits but stops dead at the outermost one. This plugin replaces those
-- four maps: it still moves between splits, but when there is no split in that
-- direction it tells tmux to switch panes instead, so one set of keys walks
-- the whole layout. The tmux side only forwards the key when the pane is
-- running vim, which is what keeps the two halves from fighting.
return {
  {
    "christoomey/vim-tmux-navigator",
    -- Loading lazily on the keys means no cost when I am not inside tmux.
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to Left Window/Pane" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to Lower Window/Pane" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to Upper Window/Pane" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to Right Window/Pane" },
    },
    init = function()
      -- Write the buffer before leaving neovim for a tmux pane. Consistent
      -- with <Esc> saving, and it means I never lose an edit by navigating away.
      vim.g.tmux_navigator_save_on_switch = 1
      -- Do not wrap around at the edge of the screen; stopping is a clearer
      -- signal that there is nothing further in that direction.
      vim.g.tmux_navigator_no_wrap = 1
    end,
  },
}
