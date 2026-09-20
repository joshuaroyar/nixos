{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
 
  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  hardware.enableRedistributableFirmware = true;

  # Locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # User Accounts
  users.users.joshua = {
    isNormalUser = true;
    description = "Joshua";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.fish;
  };

  # Fonts
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Shell
  programs.fish.enable = true;

  # Niri
  programs.niri.enable = true;

  systemd.user.services.niri.enableDefaultPath = false;

  # Display Manager
  programs.regreet = {
    enable = true;

    settings = {
      GTK = {
        application_prefer_dark_theme = lib.mkDefault true;
        theme_name = lib.mkDefault "Adwaita Dark";
        icon_theme_name = lib.mkDefault "Adwaita";
        cursor_theme_name = lib.mkDefault "Adwaita";
        font_name = lib.mkDefault "Cantarell 12";
      };

      background = {
        fit = "Cover";
      };
    };
  };

  # Login Manager
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";

        user = "greeter";
      };
    };
  };

  # Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Audio
  services.pipewire.enable = true;
  security.rtkit.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Podman
  virtualisation.podman = {
    enable = true;

    dockerCompat = true;

    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.containers = {
    enable = true;

    registries.search = [
      "docker.io"
      "ghcr.io"
    ];
  };

  # Pokit / Desktop Services
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

  # SSH
  services.openssh.enable = true;

  # Security
  networking.firewall.enable = true;

  security.pam.services.swaylock = { };

  # System Utilities
  environment.systemPackages = with pkgs; [
    # Basic utilities
    curl
    wget
    git
    unzip
    zip
    file
    tree

    # Hardware
    pciutils
    usbutils
    lsof

    # Networking
    inetutils

    # Monitoring
    btop

    # Build
    clang
    clang-tools
    gnumake
    pkg-config

    # Containers
    podman
    podman-compose
    buildah
    skopeo

    # Misc
    cage
    brightnessctl
  ];

  # System version
  system.stateVersion = "26.05";
}
