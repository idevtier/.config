# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./slack.nix
  ];

  home = {
    username = "idevtier";
    homeDirectory = "/home/idevtier";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  services.lorri.enable = true;

  home.packages = with pkgs; [
    socat
    eww-wayland
    slack
    hyprland-protocols
    clang
    nodejs
    (python310.withPackages(ps: with ps; [ psutil pydbus ipython ipython-sql sqlalchemy pandas sqlparse pydbus psutil ]))
    wireguard-tools
    postgresql
    rsync
    wayland
    glib
    grim
    slurp
    swappy
    wl-clipboard
    wlogout
    wlr-randr
    hyprpicker
    wpaperd
    pavucontrol
    direnv
    swaylock-effects
    brave
    seatd
    bottom
    kitty
    jq
    fd
    bat
    fzf
    curl
    wget
    ripgrep
    lazygit
    neovim
    git
    rustup
    starship
    exa
    unrar
    zip
    libnotify
    imagemagick
    unzip
    gnome.zenity
    qmk
    traceroute
    dig
    tmux
    blueberry
    bemenu
    xdg-utils
    zathura
    pv
    transmission-gtk
    tiramisu
    inotify-tools
    psmisc
    mpv
    blender
    obs-studio
    telegram-desktop
    gparted
    xorg.xhost
    krita
    inkscape
    ngrok
    (nnn.override { withNerdIcons = true; })
    rofi-wayland
    pandoc
    neofetch
    pgcli
    steam
    zoxide
    # linuxKernel.packages.linux_zen.xpadneo
    icu

    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    font-awesome
    noto-fonts
    noto-fonts-emoji

    sddm
    pmutils
    cava

    slides
    vivaldi
    libreoffice
  ];

  fonts.fontconfig.enable = true;
}
