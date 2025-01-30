# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth = {
    enable = true;
    themePackages = with pkgs; [
      adi1090x-plymouth-themes
      catppuccin-plymouth
      kdePackages.breeze-plymouth
      nixos-bgrt-plymouth
    ];
  };
 
  boot.kernelParams = [
    "splash"
    "quiet"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "pcie_port_pm=off"
  ];

  boot.initrd = {
    kernelModules = [
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];
    luks.devices = {
      "luks-d22887f8-10e8-428a-8815-6400ced92898" = {
        device = "/dev/disk/by-uuid/d22887f8-10e8-428a-8815-6400ced92898";
      };
    };
  };
  
  networking = {
    hostName = "sortsol";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      extraCommands = '' 
        iptables -A INPUT -p tcp -s 10.0.0.12/24 --dport 1714:1764
        iptables -A INPUT -p udp -s 10.0.0.12/24 --dport 1714:1764
        iptables -A INPUT -p tcp -s 10.0.0.12/24 --dport 9090
      '';
    };
  };

  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_US.UTF-8";

  fonts.packages = with pkgs; [
    powerline-fonts
    powerline-symbols
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
    extraPackages = with pkgs; [
      sddm-astronaut
      sddm-sugar-dark
    ];
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us,no";
    variant = "";
  };

  services.printing.enable = true;

  hardware.logitech.wireless.enable = true;

  services.pulseaudio.enable = false;
  
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
       nvidia-vaapi-driver
    ];
  };

  programs.nix-required-mounts.presets.nvidia-gpu.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    forceFullCompositionPipeline = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    #prime = {
    #  offload.enableOffloadCmd = true;
    #  reverseSync.enable = true;
    #};
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.steam = {
    enable = true;
    extest.enable = true;
    protontricks.enable = true;
    extraPackages = with pkgs; [
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      steamtinkerlaunch
    ];
    gamescopeSession = {
      enable = true;
      args = [];
      env = {};
    };
  };

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    user = "ollama";
    loadModels = [
      "dolphin-mixtral"
      "llava-phi3"
      "deepseek-r1:14b"
      "deepseek-coder-v2"
    ];
  };

  services.nextjs-ollama-llm-ui = {
    enable = true;
    port = 3000;
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-direct";
    clock24 = true;
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
    ];
  };

  programs.starship.enable = true;

  programs.waybar.enable = false;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  xdg = {
    portal = {
      enable = true;
      config = {
        common.default = [ "kde" "gtk" ];
      };
    };
  };

  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  hardware.nvidia-container-toolkit.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withNodeJs = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    zellij starship fzf fwupd-efi htop wget vim git mpv libva libva-utils vdpauinfo libvdpau fastfetch pciutils nvidia-system-monitor-qt

    vkmark polonium solaar logitech-udev-rules dmidecode

    vulkan-tools clinfo plasma-panel-colorizer qutebrowser resvg
    wayland-pipewire-idle-inhibit vulnix flatpak-builder xdg-dbus-proxy libportal-qt6 krunner-translator

    kdePackages.qtbase kdePackages.kconfig kdePackages.plasma-firewall kdePackages.plasma-vault kdePackages.kdeconnect-kde
    kdePackages.sddm-kcm kdePackages.plymouth-kcm kdePackages.plasma-disks kdePackages.partitionmanager kdePackages.kdesu
    kdePackages.kde-gtk-config appimage-run kdePackages.kcachegrind kdePackages.kcalc kdePackages.kalarm kdePackages.isoimagewriter
    kdePackages.flatpak-kcm kdePackages.filelight kdePackages.dolphin-plugins kdePackages.discover kdePackages.accounts-qt
    kdePackages.kpipewire kdePackages.sonnet 

    aspell aspellDicts.en aspellDicts.en-science aspellDicts.en-computers aspellDicts.nn aspellDicts.nb

    krita gamemode gamescope mangohud bottles lutris heroic gogdl sqlite tmuxifier

    llvmPackages.libcxxClang valgrind conda python312 python312Packages.pip python312Packages.pylatexenc gperftools godot_4 asdf-vm

    lua51Packages.lua lua51Packages.luarocks-nix luajit luajitPackages.luarocks-nix zig nodePackages_latest.nodejs nodePackages_latest.yarn

    julia distrobox podman-tui devpod devpod-desktop 

    tree-sitter fish-lsp lua-language-server zls vim-language-server nginx-language-server tailwindcss-language-server kotlin-language-server bash-language-server cmake-language-server autotools-language-server arduino-language-server ansible-language-server
  ];

  environment.sessionVariables = {
     KWIN_DRM_ALLOW_NVIDIA_COLORSPACE = 1;
  };

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  users.users.oasf = {
    isNormalUser = true;
    description = "Ole A. Sjo Fasting";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "podman" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      alacritty zed-editor ktorrent 
    ];
  };

  system.stateVersion = "24.11";
}
