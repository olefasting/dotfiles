if [ "$INSTALL_TASKS_SH_SOURCED" == "1" ]; then return; fi
INSTALL_TASKS_SH_SOURCED=1



function install_asdf() {
  create_dirs asdf data
}

function install_alacritty() {
  create_dirs alacritty config
  create_symlink "$PWD/alacritty/alacritty.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  create_symlink "$PWD/alacritty/catppuccin-mocha.toml" "$XDG_CONFIG_HOME/alacritty/catppuccin-mocha.toml"
  return 0
}

function install_git() {
  create_symlink "$PWD/git/gitconfig" "$XDG_CONFIG_HOME/.gitconfig"
  return 0
}

function install_helix() {
  create_dirs helix config data
  create_symlink "$PWD/helix/config.toml" "$XDG_CONFIG_HOME/helix/config.toml"
  create_symlink "$PWD/helix/languages.toml" "$XDG_CONFIG_HOME/helix/languages.toml"
  create_symlink "$PWD/helix/themes" "$XDG_CONFIG_HOME/helix/themes"
  return 0
}

function install_kakoune() {
  create_dirs kak config data
  create_symlink "$PWD/kakoune/kakrc" "$XDG_CONFIG_HOME/kak/kakrc"
  create_symlink "$PWD/kakoune/kak-lsp.toml" "$XDG_CONFIG_HOME/kak/kak-lsp.toml"
  create_symlink "$PWD/kakoune/autoload" "$XDG_CONFIG_HOME/kak/autoload"
  create_symlink "$PWD/kakoune/colors" "$XDG_CONFIG_HOME/kak/colors"
  return 0
}

function install_neovim() {
  create_dirs nvim config data
  create_symlink "$PWD/nvim/.luarc.json" "$XDG_CONFIG_HOME/nvim/.luarc.json"
  create_symlink "$PWD/nvim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
  create_symlink "$PWD/nvim/lazy-lock.json" "$XDG_CONFIG_HOME/nvim/lazy-lock.json"
  create_symlink "$PWD/nvim/lua" "$XDG_CONFIG_HOME/nvim/lua"
  return 0
}

function install_tree_sitter() {
  create_dirs tree-sitter config
  create_symlink "$PWD/tree-sitter/config.json" "$XDG_CONFIG_HOME/tree-sitter/config.json"
  return 0
}

function install_zed() {
  create_dirs zed config data
  create_symlink "$PWD/zed/settings.json" "$XDG_CONFIG_HOME/zed/settings.json"
  return 0
}

function install_zsh() {
  create_dirs zsh data config
  create_symlink "$PWD/zsh/zshenv" "$HOME/.zshenv"
  create_symlink "$PWD/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"
  create_symlink "$PWD/zsh/modules" "$XDG_CONFIG_HOME/zsh/modules"
  create_symlink "$PWD/zsh/autoload" "$XDG_CONFIG_HOME/zsh/autoload"
  return 0  
}

function install_zellij() {
  create_dirs zellij config data
  create_symlink "$PWD/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/config.kdl"
  create_symlink "$PWD/zellij/layouts" "$XDG_CONFIG_HOME/zellij/layouts"
  create_symlink "$PWD/zellij/plugins" "$XDG_CONFIG_HOME/zellij/plugins"
  create_symlink "$PWD/zellij/themes" "$XDG_CONFIG_HOME/zellij/themes"
  return 0
}

function install_editor() {
  local _editor="$1"
  if [[ -z "$_editor" ]]; then
    error "install_editor requires one parameter"
    return 0
  fi
  case "$_editor" in
    neovim|nvim)
      install_neovim
      ;;
    helix|hx)
      install_helix
      ;;
    kakoune|kak)
      install_kakoune
      ;;
    zeditor|zed)
      install_zed
      ;;
    *)
      warn "install_editor unknown editor parameter '$_editor'"
      return 1
      ;;
  esac
  unset _editor
  return 0
}
