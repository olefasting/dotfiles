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

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  fonts.packages = with pkgs; [
    nerdfonts
    powerline-fonts
    powerline-symbols
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,no";
    variant = "";
  };

  services.printing.enable = true;

  hardware.logitech.wireless.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
       nvidia-vaapi-driver
    ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    forceFullCompositionPipeline = false;

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
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

  programs.waybar.enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
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

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    fwupd-efi htop wget vim git mpv libva libva-utils vdpauinfo libvdpau fastfetch pciutils nvidia-system-monitor-qt

    vkmark polonium solaar logitech-udev-rules

    vulkan-tools clinfo plasma-panel-colorizer qutebrowser resvg
    wayland-pipewire-idle-inhibit vulnix flatpak-builder xdg-dbus-proxy libportal-qt6 krunner-translator

    kdePackages.qtbase kdePackages.kconfig kdePackages.plasma-firewall kdePackages.plasma-vault kdePackages.kdeconnect-kde
    kdePackages.sddm-kcm kdePackages.plymouth-kcm kdePackages.plasma-disks kdePackages.partitionmanager kdePackages.kdesu
    kdePackages.kde-gtk-config appimage-run kdePackages.kcachegrind kdePackages.kcalc kdePackages.kalarm kdePackages.isoimagewriter
    kdePackages.flatpak-kcm kdePackages.filelight kdePackages.dolphin-plugins kdePackages.discover kdePackages.accounts-qt
    kdePackages.kpipewire kdePackages.sonnet 

    aspell aspellDicts.en aspellDicts.en-science aspellDicts.en-computers aspellDicts.nn aspellDicts.nb

    krita gamemode gamescope mangohud bottles lutris heroic gogdl sqlite

    valgrind neovim conda python312 python312Packages.pip gperftools godot_4 zig asdf

    lua51Packages.lua lua51Packages.luarocks-nix luajit luajitPackages.luarocks-nix

    tree-sitter fish-lsp lua-language-server zls vim-language-server nginx-language-server
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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      alacritty zed-editor ktorrent 
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
