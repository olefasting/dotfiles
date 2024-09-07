[ -e "$XDG_CONFIG_HOME/zellij" ] || mkdir -p "$XDG_CONFIG_HOME/zellij"
[ -e "$XDG_CONFIG_HOME/zellij/config.kdl" ] && mv "$XDG_CONFIG_HOME/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/config.kdl.bak"
cp "$PWD/$PROJECT__module_folder_name/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/config.kdl"
