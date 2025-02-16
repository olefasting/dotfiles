#!/usr/bin/env bash

set -e

DOTFILES_DIR=$(readlink -f "$0" | xargs -0 dirname)

cd "$DOTFILES_DIR"

export DOTFILES_DIR

dotfiles_installed=()

source "$DOTFILES_DIR/scripts/logging.sh"
source "$DOTFILES_DIR/scripts/install_helpers.sh"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

[[ ! -e "$XDG_CONFIG_HOME" ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ ! -e "$XDG_DATA_HOME" ]] || mkdir -p "$XDG_DATA_HOME"
[[ ! -e "$XDG_CACHE_HOME" ]] || mkdir -p "$XDG_CACHE_HOME"

DEBUG="${DEBUG:-0}"
BACKUP="${BACKUP:-0}"

function __install_asdf() {
  if ! command -v asdf >/dev/null 2>&1 &&
    ! command -v asdf-vm >/dev/null 2>&1; then
    debug "install_asdf asdf binary not found, attempting install"
    yay --noconfirm --noprogressbar -Syq asdf-vm
  fi
  mkdir -p "$XDG_DATA_HOME/asdf"
  set +e
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin add zig https://github.com/asdf-community/asdf-zig.git
  asdf install
  set -e
  return 0
}

function __install_alacritty() {
  if ! command -v alacritty >/dev/null 2>&1; then
    debug "install_alacritty alacritty binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq alacritty
  fi
  mkdir -p "$XDG_CONFIG_HOME/alacritty"
  create_symlink "$DOTFILES_DIR/alacritty/alacritty.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  create_symlink "$DOTFILES_DIR/alacritty/catppuccin-mocha.toml" "$XDG_CONFIG_HOME/alacritty/catppuccin-mocha.toml"
  return 0
}

function __install_ghostty() {
  if ! command -v ghostty >/dev/null 2>&1; then
    debug "install_ghostty ghostty binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq ghostty
  fi
  mkdir -p "$XDG_CONFIG_HOME/ghostty"
  create_symlink "$DOTFILES_DIR/ghostty/config" "${XDG_CONFIG_HOME}/ghostty/config"
  return 0
}

function __install_git() {
  if ! command -v git >/dev/null 2>&1; then
    debug "install_git git binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq git
  fi
  create_symlink "$DOTFILES_DIR/git/gitconfig" "$XDG_CONFIG_HOME/.gitconfig"
  return 0
}

function __install_helix() {
  if ! command -v hx >/dev/null 2>&1 &&
    ! command -v helix >/dev/null 2>&1; then
    debug "install_helix hx/helix binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq helix
  fi
  mkdir -p "${XDG_CONFIG_HOME}/helix"
  mkdir -p "${XDG_DATA_HOME}/helix"
  create_symlink "$DOTFILES_DIR/helix/config.toml" "$XDG_CONFIG_HOME/helix/config.toml"
  create_symlink "$DOTFILES_DIR/helix/languages.toml" "$XDG_CONFIG_HOME/helix/languages.toml"
  create_symlink "$DOTFILES_DIR/helix/themes" "$XDG_CONFIG_HOME/helix/themes"
  return 0
}

function __install_kakoune() {
  if ! command -v kak >/dev/null 2>&1 &&
    ! command -v kakoune >/dev/null 2>&1; then
    debug "install_kakoune kak/kakoune binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq kakoune kakoune-lsp
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
  if ! command -v nvim >/dev/null 2>&1 &&
    ! command -v neovim >/dev/null 2>&1; then
    debug "install_neovim nvim/neovim binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq neovim neovim-lspconfig
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
  if ! command -v rustup >/dev/null 2>&1; then
    debug "install_rustup rustup binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq rustup
  fi
  return 0
}

function __install_sheldon() {
  local _shell="${DOTFILES_SHELL:-$(basename $SHELL)}"
  if [[ " ${dotfiles_installed[*]} " =~ [[:space:]]$_shell[[:space:]] ]]; then
    install "$_shell"
  fi
  if ! command -v sheldon >/dev/null 2>&1; then
    debug "install_sheldon sheldon binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq sheldon
  fi
  local _filepath="$DOTFILES_DIR/sheldon/plugins.${_shell}.toml"
  if [[ ! -e "$_filepath" ]]; then
    error "install_sheldon($_shell) the config file for shell '$_shell' could not be found ($_filepath)"
    return 1
  fi
  mkdir -p "${XDG_CONFIG_HOME}/sheldon"
  mkdir -p "${XDG_DATA_HOME}/sheldon"
  create_symlink "${_filepath}" "${XDG_CONFIG_HOME}/sheldon/plugins.toml"
  return 0
}

function __install_starship() {
  local _shell="${DOTFILES_SHELL:-$(basename $SHELL)}"
  if [[ " ${dotfiles_installed[*]} " =~ [[:space:]]$_shell[[:space:]] ]]; then
    install "$_shell"
  fi
  if ! command -v starship >/dev/null 2>&1; then
    debug "install_starship starship binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq starship
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
  if ! command -v tree-sitter >/dev/null 2>&1; then
    debug "install_tree_sitter tree-sitter binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq tree-sitter
  fi
  mkdir -p "${XDG_CONFIG_HOME}/tree-sitter"
  create_symlink "$DOTFILES_DIR/tree-sitter/config.json" "$XDG_CONFIG_HOME/tree-sitter/config.json"
  return 0
}

function __install_zed() {
  if ! command -v zed >/dev/null 2>&1 &&
    ! command -v zeditor >/dev/null 2>&1; then
    debug "install_zed zed/zeditor binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq zed
  fi
  mkdir -p "${XDG_CONFIG_HOME}/zed"
  mkdir -p "${XDG_DATA_HOME}/zed"
  create_symlink "$DOTFILES_DIR/zed/settings.json" "$XDG_CONFIG_HOME/zed/settings.json"
  return 0
}

function __install_zellij() {
  if ! command -v zellij >/dev/null 2>&1; then
    debug "install_zellij zellij binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq zellij
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
  if ! command -v zsh >/dev/null 2>&1; then
    debug "install_zsh zsh binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq zsh
  fi
  mkdir -p "${XDG_CONFIG_HOME}/zsh"
  mkdir -p "${XDG_DATA_HOME}/zsh"
  create_symlink "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
  create_symlink "$DOTFILES_DIR/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"
  create_symlink "$DOTFILES_DIR/zsh/autoload" "$XDG_CONFIG_HOME/zsh/autoload"
  create_symlink "$DOTFILES_DIR/zsh/zshenv.d" "$XDG_CONFIG_HOME/zsh/zshenv.d"
  create_symlink "$DOTFILES_DIR/zsh/zshrc.d" "$XDG_CONFIG_HOME/zsh/zshrc.d"
  DOTFILES_SHELL="zsh"
  return 0
}

function install() {
  local _name
  _name="$1"
  if [[ -z "$1" ]]; then
    warning "install requires a package name as its first parameter"
    return 1
  fi
  for _name in "$@"; do
    if [[ " ${dotfiles_installed[*]} " =~ [[:space:]]$_name[[:space:]] ]]; then
      warning "install called for '$_name', but '$_name' is already installed"
      return 0
    fi
    case "$_name" in
    asdf)
      __install_asdf
      ;;
    acritty)
      __install_alacritty
      ;;
    ghostty)
      __install_ghostty
      ;;
    git)
      __install_git
      ;;
    helix | hx)
      _name="helix"
      __install_helix
      ;;
    kakoune | kak)
      _name="kakoune"
      __install_kakoune
      ;;
    neovim | nvim)
      _na="neovim"
      __install_neovim
      ;;
    rustup)
      __install_rustup
      ;;
    sheldon)
      __install_sheldon
      ;;
    starship)
      __install_starship
      ;;
    tree-sitter | tree_sitter | treesitter)
      _name="tree-sitter"
      __install_tree_sitter
      ;;
    zed | zeditor)
      _name="zed"
      __install_zed
      ;;
    zellij)
      __install_zellij
      ;;
    zsh)
      __install_zsh
      ;;
    *)
      warn "install was called with package name '$_name', but that package does not exist"
      return 1
      ;;
    esac
    dotfiles_installed+=("name")
    debug "install for '$_name' completed successfully"
  done
  return 0
}

info "installing to user ${USER}'s home directory ($HOME)"

if [[ "$DEBUG" == "1" ]]; then
  info "DEBUG     = '1' (on)"
else
  info "DEBUG     = '$DEBUG' (off)"
fi

install git asdf ghostty zellij starship zsh sheldon helix zed tree-sitter

info "all installation tasks completed successfully!"
