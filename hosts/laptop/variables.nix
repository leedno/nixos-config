{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "leedno";
  gitEmail = "leon.nordell04@gmail.com";

  # Set Display Manager
  # `tui` for Text login
  # `sddm` for graphical GUI (default)
  # SDDM background is set with stylixImage
  displayManager = "sddm";

  # Emable/disable bundled applications
  tmuxEnable = true;
  alacrittyEnable = false;
  vscodeEnable = false;
  antigravityEnable = false;
  obsEnable = false;
  zenEnable = false;

  # Python development tools are included by default

  # Hyprland Settings
  # Examples:
  # extraMonitorSettings = "monitor = Virtual-1,1920x1080@60,auto,1";
  # extraMonitorSettings = "monitor = HDMI-A-1,1920x1080@60,auto,1";
  # You can configure multiple monitors.
  # Inside the quotes, create a new line for each monitor.
  extraMonitorSettings = "monitor=eDP-1,1920x1080@120,auto,1";

  # Bar/Shell Settings
  # Choose between noctalia or waybar
  barChoice = "noctalia";

  # Program Options
  # Set Default Browser (google-chrome-stable for google-chrome)
  # This does NOT install your browser
  # You need to install it by adding it to the `packages.nix`
  # or as a flatpak
  browser = "brave";

  # Available Options:
  # Kitty, Alacritty
  # Note: kitty, alacritty have to be enabled in `variables.nix`
  # Setting it here does not enable it. Kitty is installed by default
  terminal = "kitty"; # Set Default System Terminal

  # controls stuff like battery icon
  isLaptop = true;

  keyboardLayout = "se";
  keyboardVariant = "";
  consoleKeyMap = "us";

  # For hybrid support (Intel/NVIDIA Prime or AMD/NVIDIA)
  intelID = "PCI:1:0:0";
  amdgpuID = "PCI:03:00.0";
  nvidiaID = "PCI:0:2:0";

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = false;

  # Enable Thunar GUI File Manager
  # Yazi is default File Manager
  thunarEnable = true;

  # Themes, waybar and animation.
  #  Only uncomment your selection
  # The others much be commented out.

  # Default background
  #wallpaperUrl = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/landscapes/forrest.png";
  #wallpaperSha = "00qx3h60s92hmf09ik1s3984jym6li270201qqzs5x4yks7q6flc";

  stylixImage = ../../wallpapers/dark-whale.png;

  # Set Animation style
  # Available options are:
  animChoice = ../../modules/home/hyprland/animations-def.nix;
  #animChoice = ../../modules/home/hyprland/animations-end4.nix;
  #animChoice = ../../modules/home/hyprland/animations-end4-slide.nix;
  #animChoice = ../../modules/home/hyprland/animations-end-slide.nix;
  #animChoice = ../../modules/home/hyprland/animations-dynamic.nix;
  #animChoice = ../../modules/home/hyprland/animations-moving.nix;
  #animChoice = ../../modules/home/hyprland/animations-hyde-optimized.nix;
  #animChoice = ../../modules/home/hyprland/animations-mahaveer-me-1.nix;
  #animChoice = ../../modules/home/hyprland/animations-mahaveer-me-2.nix;
  #animChoice = ../../modules/home/hyprland/animations-ml4w-classic.nix;
  #animChoice = ../../modules/home/hyprland/animations-ml4w-fast.nix;
  #animChoice = ../../modules/home/hyprland/animations-ml4w-high.nix;

  # Set network hostId if required (needed for zfs)
  # Otherwise leave as-is
  hostId = "5ab03f50";
}
