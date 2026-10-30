-- Nix integration.
--
-- Mason is the one piece of LazyVim that genuinely does not fit a nix setup.
-- It downloads prebuilt binaries into ~/.local/share/nvim/mason at runtime,
-- which means the toolchain is unpinned, invisible to the flake, and often
-- linked against a loader or libraries that do not exist on this machine.
-- Every tool LazyVim would have installed through Mason is declared in
-- home.nix instead, so `darwin-rebuild switch` is the only thing that moves it.
--
-- This is safe to do: LazyVim gates every Mason call behind
-- LazyVim.has("mason.nvim") / LazyVim.has("mason-lspconfig.nvim"). With the
-- plugins disabled it falls back to enabling each server directly through
-- vim.lsp.enable(), resolving the binary from PATH, which is exactly what we
-- want. See lazyvim/plugins/lsp/init.lua and extras/dap/core.lua.
return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },

  -- Python debugging. LazyVim's python extra calls
  -- require("dap-python").setup("debugpy-adapter"), resolved from PATH.
  -- home.nix provides that wrapper, pointing at a python that has debugpy,
  -- so it does not depend on whatever python happens to be first on PATH.
  {
    "mfussenegger/nvim-dap-python",
    optional = true,
    config = function()
      require("dap-python").setup(vim.fn.exepath("debugpy-adapter"))
    end,
  },

  -- Rust debugging. LazyVim only wires codelldb up when Mason is present, and
  -- it looks for liblldb under $MASON. With Mason off, point rustaceanvim at
  -- the two halves of the nix codelldb package, exported by home.nix.
  {
    "mrcjkb/rustaceanvim",
    optional = true,
    opts = function(_, opts)
      local codelldb = vim.env.CODELLDB_PATH or ""
      local liblldb = vim.env.CODELLDB_LIBLLDB_PATH or ""
      if codelldb ~= "" and liblldb ~= "" then
        opts.dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, liblldb),
        }
      end
      return opts
    end,
  },

  -- nvim-treesitter's main branch compiles each parser with the tree-sitter
  -- CLI plus a C compiler. Both come from nix / the Xcode command line tools,
  -- so just fail loudly if the CLI is missing rather than leaving every
  -- language silently unhighlighted.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      if vim.fn.executable("tree-sitter") == 0 then
        vim.schedule(function()
          LazyVim.error("`tree-sitter` CLI not found. Add it to home.nix.", { title = "treesitter" })
        end)
      end
    end,
  },
}
