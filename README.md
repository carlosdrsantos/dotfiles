# dotfiles

nix-darwin + home-manager config for my Mac. `configuration.nix` holds system settings and
Homebrew apps, `home.nix` holds CLI tools, shell and the links into `home/`.

## New machine

1. Install the Xcode command line tools: `xcode-select --install`
2. Install [Determinate Nix](https://determinate.systems/nix-installer/)
3. Sign in to the App Store (Bitwarden is installed from there)
4. Clone and build:

   ```sh
   git clone https://github.com/carlosdrsantos/dotfiles.git ~/github/carlossantos/dotfiles
   ~/github/carlossantos/dotfiles/rebuild.sh
   ```

   `rebuild.sh` links `~/.dotfiles` to the clone, which `home.nix` expects, and bootstraps
   nix-darwin on the first run. Use it for every rebuild after that too.
5. Install Claude Code: `curl -fsSL https://claude.ai/install.sh | bash`
6. Install herdr's Claude hook, which `home/.claude/settings.json` calls: `herdr integration install claude`
7. Set the git identity for that machine: `git config --global user.name ...` and `user.email ...`
8. Create new SSH keys and add them to GitHub

If the new machine's account name is not `carlossantos`, change `username` in `flake.nix` first.

## Manual installs

Not available through Homebrew or the App Store:

- Nuvio
- Sleep Timer
