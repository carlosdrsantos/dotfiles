{ username, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU
  
  system.primaryUser = username;
  users.users.${username} = {
    home = "/Users/${username}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };

  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    # Don't remove unlisted packages. Note: "zap" is not a safe upgrade here - the
    # claude-code cask's zap stanza trashes ~/.local/bin/claude, ~/.local/share/claude
    # and ~/.claude*, which is where the native Claude Code install and its config live.
    onActivation.cleanup = "none";
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "herdr"
    ];
    casks = [
      "wezterm"

      # ── everyday ──
      "google-chrome"
      "firefox"
      "obsidian"
      "slack"
      "zoom"
      "whatsapp"
      "localsend"
      "stremio"

      # ── editors and ai ──
      "cursor"
      "zed"
      "visual-studio-code"
      "claude"
      "chatgpt"
      "t3-code"
      "codex"
      "codexbar"

      # ── dev ──
      "docker-desktop"
      "tableplus"
      "postgres-app"
      "http-toolkit"
    ];
    # Needs an App Store sign-in before the first rebuild.
    masApps = {
      Bitwarden = 1352778147;
    };
  };
}
