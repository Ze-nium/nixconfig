# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

# Section to define SDDM themes for SDDM to use
let 
  qylock-theme = import ./derivations/qylock.nix { inherit pkgs config lib; };
  myNeovim = import ./derivations/neovim.nix { pkgs = pkgs; };
  RQuickShare = pkgs.makeDesktopItem {
    name = "RQuickShare";
    desktopName = "RQuickShare";
    exec = "/home/kian/.local/share/applications/RQuickShare/r-quick-share-main_v0.11.5_glibc-2.39_amd64.AppImage";
    terminal = false;
    type = "Application";
    categories = [ "Utility" ];
    icon = "/home/kian/.local/share/applications/RQuickShare/rquickshare.svg";
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot-configuration.nix
      ./qemu-hardware-configuration.nix
      ./modules/qylock/qylock.nix
    ];


  # Enable NixOS experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  qt.enable = true;

  services.flatpak.enable = true;
  services.openssh.enable = true;
  # services.cron = {
  #   enable = true;
  # systemCronJobs = [
  #   "* * * * * kian /bin/bash hyprsunset -t 1400K" 
  # };

  # Systemd Timers
  # systemd.timers."redshift" = {
  #   wantedBy = [ "timers.target" ];
  #     timerConfig = {
  #       OnCalendar = "*-*-* 21-30-*";
  #   Persistent = true;
  #   Unit = "redshift.service";
  #     };
  # };

  # systemd.services."redshift" = {
  #   script = ''
  #     XDG_RUNTIME_DIR=/run/user/1000 DISPLAY=:0 WAYLAND_DISPLAY=wayland-1 ${pkgs.hyprsunset}/bin/hyprsunset -t 1400K 
  #     brightnessctl set 10%
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "kian";
  #   };
  # };

  systemd.services.systemd-logind.serviceConfig.Environment = [
    "SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK=1"
  ];
  systemd.services.systemd-hibernate = {
    serviceConfig.ExecStartPre = [
      "-/bin/sh -c 'echo 3 > /proc/sys/vm/drop_caches'"
    ];
  };
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "en_SG.UTF-8";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "en_SG.UTF-8";
    LC_TIME = "en_SG.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure fonts
  console.font = "Lat2-Terminus16";
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.sansSerif= [ "Open Sans" ];
  fonts.fontconfig.allowBitmaps = true;
	fonts.packages = with pkgs; [
	    noto-fonts
	    montserrat
	    nerd-fonts.fira-code
	    nerd-fonts.jetbrains-mono
	    noto-fonts-color-emoji
	    font-awesome_4
	    font-awesome_5
	    font-awesome_6
	    open-sans
	    terminus_font
	];

  programs.dconf.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.bash = {
    shellAliases = {
      ll = "ls -al";
      nix-rebuild = "sudo nixos-rebuild switch";
      nixconf = "nvim /home/kian/nixconfig/configuration.nix";
      hyprconf = "nvim /home/kian/.config/hypr/hyprland.lua";
      vmng = "python3 /home/kian/Homelab/Scripts/vmng.py";
      quickshell = "quickshell -p /home/kian/quickshell/";
    };
    promptInit = ''
      source /home/kian/.bash/themes/aphrodite/aphrodite.theme.sh
      export HYPRCONF="/home/kian/.config/hypr/"
    '';
};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."kian" = {
    isNormalUser = true;
    description = "kian";
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    packages = with pkgs; [
      hyprpaper
      hyprcursor
      hyprsunset
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Configure manpages
  documentation.enable = true;
  documentation.man.enable = true;
  documentation.man.cache.enable = true;
  documentation.dev.enable = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  virtualisation.waydroid.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Terminal Packages
    vim 
    btop
    curl
    git
    wget
    file
    fastfetch
    man-pages
    man-pages-posix
    binutils.man
    zip
    myNeovim
    ripgrep
    ripgrep-all
    gdu
    bluetui
    playerctl

    # Standard Applications
    kitty
    firefox
    nemo
    kdePackages.dolphin
    obsidian
    calibre
    RQuickShare # Desktop Entry for the AppImage
    pear-desktop # Electron App for YouTube Music
    looking-glass-client
    proton-pass
    proton-pass-cli
    osu-lazer
    
    # Miscellaneous Applications
    hyprlock
    eww
    rofi # Application Launcher
    nwg-look
    kdePackages.breeze

    # Lower Level Applications and Packages
    librsvg
    python3
    python3Packages.pip
    papirus-nord
    brightnessctl
    qemu_full
    OVMFFull
    iptables # For legacy applications that require it like Waydroid
    nftables
    qylock-theme
    quickshell
    # Qt6 stuff
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qt5compat
    wl-clipboard

    # Pacakges for neovim
    lua-language-server
    pyright
    nixd
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    AQ_NO_MODIFIERS = "1";
    VULKAN_DRIVER = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    KWIN_DRM_NO_AMS = "1";
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.libinput.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
    qylock.theme = "pixel-night-city";
    qylock.clockwork.theme = "orbital";
    theme = "${config.services.displayManager.sddm.qylock.theme}";
    package = pkgs.kdePackages.sddm;
    extraPackages = [ 
      pkgs.kdePackages.breeze
      pkgs.qt6.qtbase
      pkgs.qt6.qtdeclarative
      pkgs.qt6.qt5compat
      pkgs.qt6.qtmultimedia
      pkgs.qt6.qtsvg
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-good   # Good-quality plugins under LGPL
      pkgs.gst_all_1.gst-plugins-bad    # Plugins with less-certain quality/license
      pkgs.gst_all_1.gst-plugins-ugly   # Good plugins with potential redistribution issues
      pkgs.gst_all_1.gst-libav          # FFmpeg based plugins (for more codecs)
      pkgs.gst_all_1.gst-devtools
      qylock-theme
    ];
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
