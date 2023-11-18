# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
    lib,
    config,
    pkgs,
    ...
}: {
# You can import other NixOS modules here
  imports = [
# If you want to use modules from other flakes (such as nixos-hardware):
# inputs.hardware.nixosModules.common-cpu-amd
# inputs.hardware.nixosModules.common-ssd

# You can also split up your configuration and import pieces of it here:
# ./users.nix

# Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./home-manager.nix
  ];

  nix = {
# This will add each flake input as a registry
# To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

# This will additionally add your inputs to the system's legacy channels
# Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
# Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
# Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };
  programs.nix-ld.enable = true;

  networking = {
    hostName = "idevtierNixOs";
    firewall.enable = lib.mkForce true;
    networkmanager.enable = lib.mkDefault true; # run nmtui for wi-fi
    useDHCP = false;
    interfaces.wlp2s0.useDHCP = true;
  };

# Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = ["resume_offset=17917952"];
    resumeDevice = "/dev/disk/by-uuid/e2349397-1694-4344-91ea-61e176e7f6c3";
  };

# Set your time zone.
  time.timeZone = "Europe/Moscow";

# Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  users.users = {
    idevtier = {
      isNormalUser = true;
      description = "idevtier";
      extraGroups = [ "networkmanager" "wheel" "audio" "input" "video" "docker" "adbusers" "libvirtd" ];
      shell = pkgs.fish;
    };
  };

# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  nixpkgs = {
    overlays = [
    ];
    config = {
# Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
      '';
  };


  environment.systemPackages = with pkgs; [
    git
    pinentry-curses
    virt-manager
    pinentry-bemenu
    spice-gtk
  ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings

  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
  };

  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.blueman.enable = true;
  services.udev.packages = with pkgs; [
    via
  ];

# hybrid sleep when press power button
  # services.logind.extraConfig = ''
  #   HandlePowerKey=suspend
  #   IdleAction=hyprid-sleep
  #   IdleActionSec=1m
  #   '';

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
    ];
    wlr = {
      enable = true;
      settings = { # uninteresting for this problem, for completeness only
        screencast = {
          output_name = "eDP-1";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };

  programs = {
    xss-lock.enable = true;
    fish.enable = true;
    light.enable = true;
    hyprland = {
      enable = true;
      xwayland = {
        hidpi = true;
        enable = true;
      };
    };

    waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          });
    };
  };

  environment.shells = with pkgs; [ fish ];
  virtualisation.docker.enable = true;

  environment.sessionVariables = {
    PATH = [
      "$HOME/.config/bin"
      "$HOME/.cargo/bin"
    ];
    HYPRSHOT_DIR = "$HOME/images/screenshots";
    NIXOS_OZONE_WL = "1";
    POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };
}
