
{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";

  # ── neovim debug adapters ───────────────────────────────────────────────────
  # Both of these are normally installed by mason.nvim. LazyVim's clangd, rust
  # and python extras look them up by name on PATH, so a wrapper each is all
  # that is needed to move them into the flake. See home/.config/nvim/lua/plugins/nix.lua.

  # codelldb ships as a vscode extension: the adapter binary and the liblldb it
  # dlopens sit in two different subdirectories of one store path. rustaceanvim
  # needs both, so the library path is exported as an env var further down.
  codelldbRoot =
    "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";
  codelldb = pkgs.writeShellScriptBin "codelldb" ''
    exec ${codelldbRoot}/adapter/codelldb "$@"
  '';

  # nvim-dap-python wants a `debugpy-adapter` command. Pinning the interpreter
  # here means debugging does not break when a project venv shadows python3.
  debugpy-adapter = pkgs.writeShellScriptBin "debugpy-adapter" ''
    exec ${pkgs.python3.withPackages (ps: [ ps.debugpy ])}/bin/python -m debugpy.adapter "$@"
  '';
in

{
  home.username = "carlossantos";
  home.homeDirectory = "/Users/carlossantos";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # ── cli i use constantly ──
    ripgrep   # fast search, also what snacks.picker greps with
    fd        # fast find, also what snacks.picker lists files with
    fzf       # fuzzy finder
    jq        # json on the command line
    postgresql_18  # for psql; newest client talks to older servers too
    lazygit
    neovim
    tmux
    # the font everything renders in
    nerd-fonts.hack

    # ── neovim toolchain ────────────────────────────────────────────────────
    # nvim-treesitter's main branch compiles each parser with this CLI plus a
    # C compiler; clang comes from the Xcode command line tools.
    tree-sitter

    # ── C / C++ ──
    clang-tools        # clangd and clang-format
    cmake              # neocmakelsp is not much use without it
    neocmakelsp
    cmake-format
    cmake-lint

    # ── Python ──
    basedpyright       # types
    ruff               # lint, format and import sorting

    # ── Lua ── (for editing this config)
    lua-language-server
    stylua

    # ── Nix ── (for editing this flake)
    nil                # LazyVim's nix extra uses nil_ls
    nixfmt
    statix             # nix antipattern linter

    # ── Rust ──
    rust-analyzer
    rustfmt            # rust-analyzer shells out to this to format

    # ── Go ──
    gopls
    gofumpt
    gotools            # provides goimports
    gomodifytags
    impl
    delve              # dap adapter for go

    # ── Web ──
    vtsls              # LazyVim's default typescript server
    vscode-langservers-extracted   # jsonls, html, cssls, eslint
    yaml-language-server
    taplo              # toml
    prettier          # LazyVim's conform config names this formatter "prettier"

    # ── Markdown ──
    marksman
    markdownlint-cli2
    markdown-toc

    # ── Shell ──
    bash-language-server
    shfmt

    # ── debug adapters (defined in the let block above) ──
    codelldb
    debugpy-adapter
  ];

 programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  fonts.fontconfig.enable = true;

  # Claude Code installs itself here via the official installer (claude.ai/install.sh)
  # rather than through Homebrew, so that it self-updates as soon as a release lands.
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    EDITOR = "nvim";
    # rustaceanvim needs the adapter and the library as two separate paths.
    CODELLDB_PATH = "${codelldbRoot}/adapter/codelldb";
    CODELLDB_LIBLLDB_PATH = "${codelldbRoot}/lldb/lib/liblldb.dylib";
  };

  home.file.".config/tmux".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/tmux";
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # Keep Pi's credential and runtime state local by linking only authored files and directories.
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
