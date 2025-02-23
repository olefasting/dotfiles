_PACMAN_ARGS="--noconfirm --noprogressbar -Syq"

function __install_asdf() {
  if ! has-pkg asdf-vm; then
    yay "${_PACMAN_ARGS}" asdf-vm
  fi
  mkdir -p "$XDG_DATA_HOME/asdf"
  set +e
  asdf plugin add deno https://github.com/asdf-community/asdf-deno.git
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin add zig https://github.com/asdf-community/asdf-zig.git
  asdf install
  set -e
  return 0
}

function __install_alacritty() {
  if ! has-pkg alacritty; then
    sudo pacman "${_PACMAN_ARGS}" alacritty
  fi
  mkdir -p "$XDG_CONFIG_HOME/alacritty"
  create_symlink "$DOTFILES_DIR/alacritty/alacritty.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  create_symlink "$DOTFILES_DIR/alacritty/catppuccin-mocha.toml" "$XDG_CONFIG_HOME/alacritty/catppuccin-mocha.toml"
  return 0
}

function __install_biome() {
  if ! has-pkg biome-bin; then
    yay "${_PACMAN_ARGS}" biome-bin
  fi
}

function __install_ghostty() {
  if ! has-pkg ghostty; then
    sudo pacman "${_PACMAN_ARGS}" ghostty
  fi
  if ! has-pkg ghostty; then
    sudo pacman "${_PACMAN_ARGS}" ghostty-shell-integration
  fi
  mkdir -p "$XDG_CONFIG_HOME/ghostty"
  create_symlink "$DOTFILES_DIR/ghostty/config" "${XDG_CONFIG_HOME}/ghostty/config"
  return 0
}

function __install_git() {
  if ! has-pkg git; then
    sudo pacman "${_PACMAN_ARGS}" git
  fi
  create_symlink "$DOTFILES_DIR/git/gitconfig" "$XDG_CONFIG_HOME/.gitconfig"
  return 0
}

function __install_helix() {
  if ! has-pkg helix; then
    sudo pacman "${_PACMAN_ARGS}" helix helixbinhx
  fi
  if ! has-pkg helix-gpt; then
    pacman "${_PACMAN_ARGS}" helix-gpt
  fi
  if [ -e /usr/bin/helix ] && [ ! -e /usr/bin/hx ]; then
    sudo ln -s /usr/bin/helix /usr/bin/hx
  elif [ -e /usr/bin/hx ] && [ ! -e /usr/bin/helix ]; then
    sudo ln -s /usr/bin/hx /usr/bin/helix
  fi
  mkdir -p "${XDG_CONFIG_HOME}/helix"
  mkdir -p "${XDG_DATA_HOME}/helix"
  create_symlink "$DOTFILES_DIR/helix/config.toml" "$XDG_CONFIG_HOME/helix/config.toml"
  create_symlink "$DOTFILES_DIR/helix/languages.toml" "$XDG_CONFIG_HOME/helix/languages.toml"
  create_symlink "$DOTFILES_DIR/helix/themes" "$XDG_CONFIG_HOME/helix/themes"
  return 0
}

function __install_kakoune() {
  if ! has-pkg kakoune; then
    sudo pacman "${_PACMAN_ARGS}" kakoune
  fi
  if ! has-pkg kakoune-lsp; then
    sudo pacman "${_PACMAN_ARGS}" kakoune-lsp
  fi
  mkdir -p "${XDG_CONFIG_HOME}/kak"
  mkdir -p "${XDG_DATA_HOME}/kak"
  create_symlink "$DOTFILES_DIR/kakoune/kakrc" "$XDG_CONFIG_HOME/kak/kakrc"
  create_symlink "$DOTFILES_DIR/kakoune/kak-lsp.toml" "$XDG_CONFIG_HOME/kak/kak-lsp.toml"
  create_symlink "$DOTFILES_DIR/kakoune/autoload" "$XDG_CONFIG_HOME/kak/autoload"
  create_symlink "$DOTFILES_DIR/kakoune/colors" "$XDG_CONFIG_HOME/kak/colors"
  return 0
}

function __install_neovim() {
  if ! has-pkg neovim; then
    sudo pacman "${_PACMAN_ARGS}" neovim
  fi
  if ! has-pkg neovim-lspconfig; then
    sudo pacman "${_PACMAN_ARGS}" neovim-lspconfig
  fi
  mkdir -p "${XDG_CONFIG_HOME}/nvim"
  mkdir -p "${XDG_DATA_HOME}/nvim"
  create_symlink "$DOTFILES_DIR/nvim/.luarc.json" "$XDG_CONFIG_HOME/nvim/.luarc.json"
  create_symlink "$DOTFILES_DIR/nvim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
  create_symlink "$DOTFILES_DIR/nvim/lazy-lock.json" "$XDG_CONFIG_HOME/nvim/lazy-lock.json"
  create_symlink "$DOTFILES_DIR/nvim/lua" "$XDG_CONFIG_HOME/nvim/lua"
  return 0
}

function __install_rustup() {
  if ! has-pkg rustup; then
    sudo pacman "${_PACMAN_ARGS}" rustup
  fi
  return 0
}

function __install_sheldon() {
  local _shell="${DOTFILES_SHELL:-$(basename "$SHELL")}"
  if [[ " ${dotfiles_installed[*]} " =~ [[:space:]]${_shell}[[:space:]] ]]; then
    install "$_shell"
  fi
  if ! has-pkg sheldon; then
    sudo pacman "${_PACMAN_ARGS}" sheldon
  fi
  local _filepath="$DOTFILES_DIR/sheldon/plugins.${_shell}.toml"
  if [[ ! -e "$_filepath" ]]; then
    error "install_sheldon($_shell) the config file for shell '$_shell' could not be found ($_filepath)"
    return 1
  fi
  mkdir -p "${XDG_CONFIG_HOME}/sheldon"
  mkdir -p "${XDG_DATA_HOME}/sheldon"
  create_symlink "${_filepath}" "${XDG_CONFIG_HOME}/sheldon/plugins.toml"
  case "$_shell" in
  zsh)
    if [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d" ]]; then
      warning "install_sheldon user shell is '$_shell' but the installer could not find the zshrc.d directory. Manually source '\$PWD/sheldon/for-zshrc.zsh' at the end of .zshrc to fix this"
    else
      create_symlink "$DOTFILES_DIR/sheldon/for-zshrc.zsh" "$XDG_CONFIG_HOME/zsh/zshrc.d/9999-sheldon-zsh.zsh"
    fi
    ;;
  *)
    warning "install_sheldon unable to determine user shell, or user shell is unknown. Manually determine how to initialize sheldon with your shell"
    ;;
  esac
  return 0
}

function __install_starship() {
  local _shell="${DOTFILES_SHELL:-$(basename "$SHELL")}"
  if [[ " ${dotfiles_installed[*]} " =~ [[:space:]]${_shell}[[:space:]] ]]; then
    install "$_shell"
  fi
  if ! has-pkg starship; then
    sudo pacman "${_PACMAN_ARGS}" starship
  fi
  mkdir -p "${XDG_CONFIG_HOME}/starship"
  create_symlink "$DOTFILES_DIR/starship/starship.toml" "${XDG_CONFIG_HOME}/starship/starship.toml"
  case "$_shell" in
  zsh)
    if [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d" ]]; then
      warning "install_starship user shell is '$_shell' but the installer could not find the zshrc.d directory. Manually source '\$PWD/starship/for-zshrc.zsh' at the end of .zshrc to fix this"
    else
      create_symlink "$DOTFILES_DIR/starship/for-zshrc.zsh" "$XDG_CONFIG_HOME/zsh/zshrc.d/9999-starship-prompt.zsh"
    fi
    ;;
  *)
    warning "install_starship unable to determine user shell, or user shell is unknown. Manually determine how to initialize starship with your shell"
    ;;
  esac
  return 0
}

function __install_tree_sitter() {
  if ! has-pkg tree-sitter; then
    sudo pacman "${_PACMAN_ARGS}" tree-sitter
  fi
  mkdir -p "${XDG_CONFIG_HOME}/tree-sitter"
  create_symlink "$DOTFILES_DIR/tree-sitter/config.json" "$XDG_CONFIG_HOME/tree-sitter/config.json"
  return 0
}

function __install_zed() {
  if ! has-pkg zed; then
    sudo pacman "${_PACMAN_ARGS}" zed
  fi
  mkdir -p "${XDG_CONFIG_HOME}/zed"
  mkdir -p "${XDG_DATA_HOME}/zed"
  create_symlink "$DOTFILES_DIR/zed/settings.json" "$XDG_CONFIG_HOME/zed/settings.json"
  return 0
}

function __install_ufw() {
  if ! has-pkg ufw; then
    sudo pacman "${_PACMAN_ARGS}" ufw
  fi
  if ! has-pkg ufw-extras; then
    sudo pacman "${_PACMAN_ARGS}" ufw-extras
  fi
  sudo ufw allow "KDE Connect"
  return 0
}

function __install_zellij() {
  if ! has-pkg zellij; then
    sudo pacman "${_PACMAN_ARGS}" zellij
  fi
  mkdir -p "${XDG_CONFIG_HOME}/zellij"
  mkdir -p "${XDG_DATA_HOME}/zellij"
  create_symlink "$DOTFILES_DIR/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/config.kdl"
  create_symlink "$DOTFILES_DIR/zellij/layouts" "$XDG_CONFIG_HOME/zellij/layouts"
  create_symlink "$DOTFILES_DIR/zellij/plugins" "$XDG_CONFIG_HOME/zellij/plugins"
  create_symlink "$DOTFILES_DIR/zellij/themes" "$XDG_CONFIG_HOME/zellij/themes"
  return 0
}

function __install_zsh() {
  if ! has-pkg zsh; then
    sudo pacman "${_PACMAN_ARGS}" zsh
  fi
  mkdir -p "${XDG_CONFIG_HOME}/zsh"
  mkdir -p "${XDG_CACHE_HOME}/zsh"
  create_symlink "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
  create_symlink "$DOTFILES_DIR/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"
  create_symlink "$DOTFILES_DIR/zsh/autoload" "$XDG_CONFIG_HOME/zsh/autoload"
  create_symlink "$DOTFILES_DIR/zsh/completions" "$XDG_CONFIG_HOME/zsh/completions"
  create_symlink "$DOTFILES_DIR/zsh/functions" "$XDG_CONFIG_HOME/zsh/functions"
  create_symlink "$DOTFILES_DIR/zsh/zshenv.d" "$XDG_CONFIG_HOME/zsh/zshenv.d"
  create_symlink "$DOTFILES_DIR/zsh/zshrc.d" "$XDG_CONFIG_HOME/zsh/zshrc.d"
  export DOTFILES_SHELL="zsh"
  return 0
}
