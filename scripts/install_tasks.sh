if [ "$INSTALL_TASKS_SH_SOURCED" == "1" ]; then return; fi
INSTALL_TASKS_SH_SOURCED=1

_yaycmd="yay --noconfirm --noprogressbar"
_paccmd="sudo pacman --noconfirm --noprogressbar"

function install_asdf() {
  mkdir -p "$XDG_DATA_HOME/asdf"
  if [[ ! -e "$(which asdf)" ]]; then
    eval "$_yaycmd -Syq asdf-vm"
  fi
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin add zig https://github.com/asdf-community/asdf-zig.git
  asdf install
  return 0
}

function install_alacritty() {
  mkdir -p "$XDG_CONFIG_HOME/alacritty"
  create_symlink "$PWD/alacritty/alacritty.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  create_symlink "$PWD/alacritty/catppuccin-mocha.toml" "$XDG_CONFIG_HOME/alacritty/catppuccin-mocha.toml"
  if [[ ! -e "$(which alacritty)" ]]; then
    eval "$_paccmd -Syq alacritty"
  fi
  return 0
}

function install_ghostty() {
  mkdir -p "$XDG_CONFIG_HOME/ghostty"
  create_symlink "$PWD/ghostty/config" "${XDG_CONFIG_HOME}/ghostty/config"
}

function install_git() {
  create_symlink "$PWD/git/gitconfig" "$XDG_CONFIG_HOME/.gitconfig"
  if [[ ! -e "$(which git)" ]]; then
    eval "$_paccmd -Syq git"
  fi
  return 0
}

function install_helix() {
  mkdir -p "${XDG_CONFIG_HOME}/helix"
  mkdir -p "${XDG_DATA_HOME}/helix"
  create_symlink "$PWD/helix/config.toml" "$XDG_CONFIG_HOME/helix/config.toml"
  create_symlink "$PWD/helix/languages.toml" "$XDG_CONFIG_HOME/helix/languages.toml"
  create_symlink "$PWD/helix/themes" "$XDG_CONFIG_HOME/helix/themes"
  if [[ ! -e "$(which helix)" ]]; then
    eval "$_paccmd -Syq helix"
  fi
  return 0
}

function install_kakoune() {
  mkdir -p "${XDG_CONFIG_HOME}/kak"
  mkdir -p "${XDG_DATA_HOME}/kak"
  create_symlink "$PWD/kakoune/kakrc" "$XDG_CONFIG_HOME/kak/kakrc"
  create_symlink "$PWD/kakoune/kak-lsp.toml" "$XDG_CONFIG_HOME/kak/kak-lsp.toml"
  create_symlink "$PWD/kakoune/autoload" "$XDG_CONFIG_HOME/kak/autoload"
  create_symlink "$PWD/kakoune/colors" "$XDG_CONFIG_HOME/kak/colors"
  if [[ ! -e "$(which kak)" ]]; then
    eval "$_paccmd -Syq kakoune"
  fi
  return 0
}

function install_neovim() {
  mkdir -p "${XDG_CONFIG_HOME}/nvim"
  mkdir -p "${XDG_DATA_HOME}/nvim"
  create_symlink "$PWD/nvim/.luarc.json" "$XDG_CONFIG_HOME/nvim/.luarc.json"
  create_symlink "$PWD/nvim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
  create_symlink "$PWD/nvim/lazy-lock.json" "$XDG_CONFIG_HOME/nvim/lazy-lock.json"
  create_symlink "$PWD/nvim/lua" "$XDG_CONFIG_HOME/nvim/lua"
  if [[ ! -e "$(which nvim)" ]]; then
    eval "$_paccmd -Syq neovim"
  fi
  return 0
}

function install_rustup() {
  if [[ ! -e "$(which rustup)" ]]; then
    eval "$_paccmd -Syq rustup"
  fi
  rustup default stable
  return 0
}

function install_sheldon() {
  local _shell="$1"
  mkdir -p "${XDG_CONFIG_HOME}/sheldon"
  mkdir -p "${XDG_DATA_HOME}/sheldon"
  create_symlink "$PWD/sheldon/plugins.toml" "${XDG_CONFIG_HOME}/sheldon/plugins.toml"
  if [[ ! -e "$(which sheldon)" ]]; then
    eval "$_paccmd -Syq sheldon"
  fi
  if [[ -z "$_shell" ]]; then
    return 0
  fi
  case "$_shell" in
    zsh|bash)
    sheldon init --shell "$_shell"
    ;;
    *)
    warn "install_sheldon the shell name given as a parameter is unknown ($_shell) and sheldon could therefore never be initialized"
    ;;
  esac
  
  return 0
}

function install_tree_sitter() {
  mkdir -p "${XDG_CONFIG_HOME}/tree-sitter"
  create_symlink "$PWD/tree-sitter/config.json" "$XDG_CONFIG_HOME/tree-sitter/config.json"
  if [[ ! -e "$(which tree-sitter)" ]]; then
    eval "$_paccmd -Syq tree-sitter"
  fi
  return 0
}

function install_zed() {
  mkdir -p "${XDG_CONFIG_HOME}/zed"
  mkdir -p "${XDG_DATA_HOME}/zed"
  create_symlink "$PWD/zed/settings.json" "$XDG_CONFIG_HOME/zed/settings.json"
  if [[ ! -e "$(which zeditor)" ]]; then
    eval "$_paccmd -Syq zed"
  fi
  return 0
}

function install_zsh() {
  mkdir -p "${XDG_CONFIG_HOME}/zsh"
  mkdir -p "${XDG_DATA_HOME}/zsh"
  create_symlink "$PWD/zsh/zshenv" "$HOME/.zshenv"
  create_symlink "$PWD/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"
  create_symlink "$PWD/zsh/autoload" "$XDG_CONFIG_HOME/zsh/autoload"
  if [[ ! -e "$(which zsh)" ]]; then
    eval "$_paccmd -Syq zsh"
  fi
  return 0
}

function install_zellij() {
  mkdir -p "${XDG_CONFIG_HOME}/zellij"
  mkdir -p "${XDG_DATA_HOME}/zellij"
  create_symlink "$PWD/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/config.kdl"
  create_symlink "$PWD/zellij/layouts" "$XDG_CONFIG_HOME/zellij/layouts"
  create_symlink "$PWD/zellij/plugins" "$XDG_CONFIG_HOME/zellij/plugins"
  create_symlink "$PWD/zellij/themes" "$XDG_CONFIG_HOME/zellij/themes"
  if [[ ! -e "$(which zellij)" ]]; then
    eval "$_paccmd -Syq zellij"
  fi
  return 0
}
