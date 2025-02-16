function create_symlink() {
  local _pfx=""
  local _path1="$1"
  local _path2="$2"
  if [[ -n "$3" ]] && [[ "$1" == sudo ]]; then
    _pfx="sudo "
    _path1="$2"
    _path2="$3"
  elif [[ -z "$1" ]] || [[ -z "$2" ]]; then
    error "create_symlink require two parameters"
    return 1
  fi
  if [[ ! -e "$_path1" ]]; then
    error "path '$_path1' does not exist"
    return 1
  fi
  info "creating symlink '$_path2' -> '$_path1'"
  local _folder="$(dirname $_path2)"
  if [[ ! -e "$_folder" ]]; then
    if [[ -f "$_folder" ]]; then
      error "create_symlink destination folder path exists but is not a directory (path '$_folder' must be empty or point to a directory)"
      return 1
    fi
    local _cmd="${_pfx}mkdir -p $_folder"
    eval "$_cmd"
  fi
  if [[ -e "$_path2" ]]; then
    if [[ -e "$_path2.old" ]]; then
      local _cmd="${_pfx}rm -rf ${_path2}.old"
      eval "$_cmd"
    fi
    if [[ -L "$_path2" ]]; then
      local _cmd="${_pfx}rm -f $_path2"
      eval "$_cmd"
    else
      local _cmd="${_pfx}mv $_path2 ${_path2}.old"
      eval "$_cmd"
    fi
  fi

  local _cmd="${_pfx}ln -s $_path1 $_path2"
  eval "$_cmd"

  debug "created symlink '$_path2' -> '$_path1'"

  unset _cmd
  unset _folder
  unset _pfx
  unset _path1
  unset _path2

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
