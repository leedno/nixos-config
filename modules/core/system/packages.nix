{
  pkgs,
  lib,
  host,
  ...
}: let
  vars = import ../../../hosts/${host}/variables.nix;
  inherit (vars) barChoice;

  # Noctalia-specific packages (Matugen & launcher)
  noctaliaPkgs =
    if barChoice == "noctalia"
    then
      with pkgs; [
        matugen
        app2unit
      ]
    else [];
in {
  # ---------------------------------------------------------------------------
  #  Nixpkgs Configuration (Licenses)
  # ---------------------------------------------------------------------------
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "codeium"
        "windsurf"
        "discord"
        "discord-canary"
        "steam"
        "steam-original"
        "steam-run"
        "warp-terminal"
        # Add other unfree packages here if needed
      ];
  };

  # ---------------------------------------------------------------------------
  #  System Programs & Services
  # ---------------------------------------------------------------------------
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    firefox.enable = false;
    hyprland = {
      enable = true;
      withUWSM = false;
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = true;
    hyprlock.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # ---------------------------------------------------------------------------
  #  System Packages
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs;
    noctaliaPkgs
    ++ [
      # --- System Utilities ---
      wget
      unzip
      unrar
      file-roller
      killall
      usbutils
      pciutils
      lm_sensors
      lshw
      inxi
      mesa-demos
      libnotify
      power-profiles-daemon
      upower
      uwsm # Universal Wayland Session Manager
      gpu-screen-recorder
      brightnessctl
      wl-clipboard
      cliphist
      socat
      v4l-utils
      appimage-run

      # --- Disk & Monitoring ---
      htop
      btop
      bottom
      duf
      dysk
      ncdu

      # --- CLI Tools (Better Shell Experience) ---
      eza # ls replacement
      bat # cat replacement
      ripgrep # grep replacement
      fd # find replacement
      fzf # fuzzy finder
      zoxide # cd replacement
      tldr # help replacement
      mdcat # markdown viewer
      pandoc

      # --- Development & Git ---
      git
      gh
      lazygit
      sops # Secrets management (ADDED)
      alejandra # Nix formatter
      nixfmt-rfc-style
      python3
      docker-compose
      pkg-config
      gemini-cli # (Optional)

      # --- GUI Applications ---
      brave
      warp-terminal
      discord
      discord-canary
      gimp
      eog # Image viewer
      gedit # Simple text editor
      amfora # Gemini browser

      # --- Media & Audio ---
      ffmpeg
      mpv
      rhythmbox
      pavucontrol
      playerctl
      picard
      ytmdl
      cava

      # --- Desktop / Theming ---
      waypaper
      nwg-displays
      nwg-drawer
      nwg-menu
      tuigreet

      # --- Fun / Misc ---
      cowsay
      lolcat
      cmatrix
      onefetch
    ];
}
