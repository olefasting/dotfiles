function __install_asdf() {
  if ! has-pkg asdf-vm; then
    yay -Syq --noconfirm --noprogressbar asdf-vm
  fi
  add-dir data asdf
  set +e
  asdf plugin add deno https://github.com/asdf-community/asdf-deno.git
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin add zig https://github.com/asdf-community/asdf-zig.git
  asdf plugin add zls https://github.com/dochang/asdf-zls.git
  asdf install
  set -e
  return 0
}

function __install_alacritty() {
  if ! has-pkg alacritty; then
    sudo pacman -Syq --noconfirm --noprogressbar alacritty
  fi
  add-dir config alacritty
  add-symlink alacritty/alacritty.toml
  add-symlink alacritty/catppuccin-mocha.toml
  return 0
}

function __install_biome() {
  if ! has-pkg biome-bin; then
    yay -Syq --noconfirm --noprogressbar biome-bin
  fi
  add-dir config biome
  add-symlink biome/biome.json
}

function __install_contour() {
  if ! has-pkg contour; then
    sudo pacman -Syq --noconfirm --noprogressbar contour
  fi
  add-dir config contour
  add-symlink contour/contour.yml
}

function __install_ghostty() {
  if ! has-pkg ghostty; then
    sudo pacman -Syq --noconfirm --noprogressbar ghostty
  fi
  if ! has-pkg ghostty; then
    sudo pacman -Syq --noconfirm --noprogressbar ghostty-shell-integration
  fi
  add-dir config ghostty
  add-symlink ghostty/config
  return 0
}

function __install_git() {
  if ! has-pkg git; then
    sudo pacman -Syq --noconfirm --noprogressbar git
  fi
  add-symlink git/gitconfig .gitconfig
  return 0
}

function __install_helix() {
  if ! has-pkg helix && ! has-pkg helix-git; then
    sudo pacman -Syq --noconfirm --noprogressbar helix helixbinhx
  fi
  if ! has-pkg helix-gpt; then
    pacman -Syq --noconfirm --noprogressbar helix-gpt
  fi
  if [ -e /usr/bin/helix ] && [ ! -e /usr/bin/hx ]; then
    sudo ln -s /usr/bin/helix /usr/bin/hx
  elif [ -e /usr/bin/hx ] && [ ! -e /usr/bin/helix ]; then
    sudo ln -s /usr/bin/hx /usr/bin/helix
  fi
  add-dir config helix
  add-dir data helix
  add-symlink helix/config.toml
  add-symlink helix/languages.toml
  add-symlink helix/themes
  hx --grammar fetch
  hx --grammar build
  return 0
}

function __install_hyprland() {
  if ! has-pkg hyprland; then
    yay -Syq --noconfirm --noprogressbar hyprland hyprland-protocols hyprland-qt-support hyprland-qtutils hyprland-target hyprland-workspaces xdg-desktop-portal-hyprland hyprpolkitagent hyprcursor hyprlock hypridle hyprpaper uwsm wofi
  fi
  add-dir hypr
  add-symlink hypr/hyprland.conf
}

function __install_kakoune() {
  if ! has-pkg kakoune; then
    sudo pacman -Syq --noconfirm --noprogressbar kakoune
  fi
  if ! has-pkg kakoune-lsp; then
    sudo pacman -Syq --noconfirm --noprogressbar kakoune-lsp
  fi
  add-dir config kak
  add-dir data kak
  add-symlink kakoune/kakrc kak/kakrc
  add-symlink kakoune/kak-lsp.toml kak/kak-lsp.toml
  add-symlink kakoune/autoload kak/autoload
  add-symlink kakoune/colors kak/colors
  return 0
}

function __install_mpv() {
  if ! has-pkg git; then
    install git
  fi
  if ! has-pkg ffmpeg; then
    yay -Syq --noconfirm --noprogressbar ffmpeg python-ffsubsync
  fi
  if ! has-pkg alass; then
    yay -Syq --noconfirm --noprogressbar alass
  fi
  if ! has-pkg mpv; then
    sudo pacman -Syq --noconfirm --noprogressbar mpv
  fi
  add-dir config mpv
  add-symlink mpv/shaders
  add-symlink mpv/scripts
  add-symlink mpv/script-opts
  if [[ ! -e "$XDG_CONFIG_HOME/mpv/scripts/autosubsync" ]]; then
    git clone 'https://github.com/Ajatt-Tools/autosubsync-mpv' "$DOTFILES_DIR/mpv/scripts/autosubsync"
  elif [[ ! -e "$XDG_CONFIG_HOME/mpv/scripts/autosubsync/.git" ]]; then
    local _prevpath="$PWD"
    cd "$DOTFILES_DIR/mpv/scripts/autosubsync"
    git pull
    cd "$_prevpath"
    unset _prevpath
  fi
}

function __install_neovim() {
  if ! has-pkg neovim; then
    sudo pacman -Syq --noconfirm --noprogressbar neovim
  fi
  if ! has-pkg neovim-lspconfig; then
    sudo pacman -Syq --noconfirm --noprogressbar neovim-lspconfig
  fi
  add-dir config nvim
  add-dir data nvim
  add-symlink nvim/init.lua
  add-symlink nvim/lazy-lock.json
  add-symlink nvim/lua
  return 0
}

function __install_pipewire() {
  add-dir config pipewire
  add-symlink pipewire/pipewire.conf
  add-symlink pipewire/pipewire.conf.d
  return 0
}

function __install_rustup() {
  if ! has-pkg rustup; then
    sudo pacman -Syq --noconfirm --noprogressbar rustup
  fi
  return 0
}

function __install_sheldon() {
  local _shell="${DOTFILES_SHELL:-$(basename "$SHELL")}"
  if [[ " ${dotfiles_installed[*]} " =~ [[:space:]]${_shell}[[:space:]] ]]; then
    install "$_shell"
  fi
  if ! has-pkg sheldon; then
    sudo pacman -Syq --noconfirm --noprogressbar sheldon
  fi
  local _filename="plugins.${_shell}.toml"
  if [[ ! -e "$DOTFILES_DIR/sheldon/$_filename" ]]; then
    error "install_sheldon($_shell) the config file for shell '$_shell' could not be found ($DOTFILES_DIR/sheldon/$_filename)"
    return 1
  fi
  add-dir config sheldon
  add-dir data sheldon
  add-symlink "sheldon/${_filename}" sheldon/plugins.toml
  case "$_shell" in
  zsh)
    if [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d" ]]; then
      warning "install_sheldon user shell is '$_shell' but the installer could not find the zshrc.d directory. Manually source '\$PWD/sheldon/for-zshrc.zsh' at the end of .zshrc to fix this"
    else
      add-symlink sheldon/for-zshrc.zsh zsh/zshrc.d/9999-sheldon-zsh.zsh
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
    sudo pacman -Syq --noconfirm --noprogressbar starship
  fi
  add-dir config starship
  add-symlink starship/starship.toml
  case "$_shell" in
  zsh)
    if [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d" ]]; then
      warning "install_starship user shell is '$_shell' but the installer could not find the zshrc.d directory. Manually source '\$PWD/starship/for-zshrc.zsh' at the end of .zshrc to fix this"
    else
      add-symlink starship/for-zshrc.zsh zsh/zshrc.d/9999-starship-prompt.zsh
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
    sudo pacman -Syq --noconfirm --noprogressbar tree-sitter
  fi
  add-dir config tree-sitter
  add-symlink tree-sitter/config.json
  return 0
}

function __install_zed() {
  if ! has-pkg zed; then
    sudo pacman -Syq --noconfirm --noprogressbar zed
  fi
  add-dir config zed
  add-dir data zed
  add-symlink zed/settings.json
  return 0
}

function __install_ufw() {
  if ! has-pkg ufw; then
    sudo pacman -Syq --noconfirm --noprogressbar ufw
  fi
  if ! has-pkg ufw-extras; then
    sudo pacman -Syq --noconfirm --noprogressbar ufw-extras
  fi
  sudo ufw allow "KDE Connect"
  return 0
}

function __install_zellij() {
  if ! has-pkg zellij; then
    sudo pacman -Syq --noconfirm --noprogressbar zellij
  fi
  add-dir config zellij
  add-dir data zellij
  add-symlink zellij/config.kdl
  add-symlink zellij/layouts
  add-symlink zellij/plugins
  add-symlink zellij/themes
  return 0
}

function __install_zig() {
  if ! has-pkg zig and ! has-pkg zig-git and ! has-pkg zig-nightly-bin and ! has-pkg zig-dev-bin; then
    pacman -Syq --noconfirm --noprogressbar zig
  fi
  return 0
}

function __install_zls() {
  install zig
  if ! has-pkg zls and ! has-pkg zls-git; then
    pacman -Syq --noconfirm --noprogressbar zls
  fi
  if [[ -e "$XDG_CONFIG_HOME/zsh" ]] && [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d/100-aliases.zsh" ]]; then
    add-symlink zls/aliases.zsh zsh/zshrc.d/101-aliases-zls.zsh
  fi
  add-symlink zls/config.json zls.json
  return 0
}

function __install_zsh() {
  if ! has-pkg zsh; then
    sudo pacman -Syq --noconfirm --noprogressbar zsh
  fi
  add-dir config zsh
  add-dir cache zsh
  add-symlink zsh/zshenv "$HOME/.zshenv"
  add-symlink zsh/zshrc zsh/.zshrc
  add-symlink zsh/autoload
  add-symlink zsh/completions
  add-symlink zsh/functions
  add-symlink zsh/zshenv.d
  add-symlink zsh/zshrc.d
  export DOTFILES_SHELL="zsh"
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
    if [[ " ${dotfiles_installed[*]} " =~ [[:space:]]${_name}[[:space:]] ]]; then
      warning "install called for '$_name', but '$_name' is already installed"
      return 0
    fi
    debug "attempting install for '${_name}'"
    case "$_name" in
    asdf)
      __install_asdf
      ;;
    alacritty)
      __install_alacritty
      ;;
    biome)
      __install_biome
      ;;
    contour)
      __install_contour
      ;;
    ghostty)
      __install_ghostty
      ;;
    git)
      __install_git
      ;;
    helix | hx)
      __install_helix
      ;;
    hyprland)
      __install_hyprland
      ;;
    kakoune | kak)
      __install_kakoune
      ;;
    mpv)
      __install_mpv
      ;;
    neovim | nvim)
      __install_neovim
      ;;
    pipewire)
      __install_pipewire
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
      __install_tree_sitter
      ;;
    ufw)
      __install_ufw
      ;;
    zed | zeditor)
      __install_zed
      ;;
    zellij)
      __install_zellij
      ;;
    zig)
      __install_zig
      ;;
    zls)
      __install_zls
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
