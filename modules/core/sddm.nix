{
  pkgs,
  config,
  lib,
  host,
  username,
  ...
}: let
  foreground = config.stylix.base16Scheme.base00;
  textColor = config.stylix.base16Scheme.base05;

  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = {
      # ADDED: Explicitly enable the user icon for the theme
      ShowUserIcon = "true";
      FormPosition = "left";
      HourFormat = "h:mm AP";
      HeaderTextColor = "#${textColor}";
      DateTextColor = "#${textColor}";
      TimeTextColor = "#${textColor}";
      LoginFieldTextColor = "#${textColor}";
      PasswordFieldTextColor = "#${textColor}";
      UserIconColor = "#${textColor}";
      PasswordIconColor = "#${textColor}";
      WarningColor = "#${textColor}";
      LoginButtonBackgroundColor = "#${foreground}";
      SystemButtonsIconsColor = "#${foreground}";
      SessionButtonTextColor = "#${textColor}";
      VirtualKeyboardButtonTextColor = "#${textColor}";
      DropdownBackgroundColor = "#${foreground}";
      HighlightBackgroundColor = "#${textColor}";

      # Background logic
      Background =
        if lib.hasSuffix "studio.png" config.stylix.image
        then
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/anotherhadi/nixy-wallpapers/refs/heads/main/wallpapers/studio.gif";
            sha256 = "sha256-qySDskjmFYt+ncslpbz0BfXiWm4hmFf5GPWF2NlTVB8=";
          }
        else "${toString config.stylix.image}";

      Blur =
        if lib.hasSuffix "sakura_static.png" config.stylix.image
        then "2.0"
        else "4.0";
    };
  };
in {
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [sddm-astronaut];
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      settings = let
        vars = import ../../hosts/${host}/variables.nix;
        keyboardLayout = vars.keyboardLayout or "us";
        keyboardVariant = vars.keyboardVariant or "";
      in {
        X11 = {
          XkbLayout = keyboardLayout;
          XkbVariant = keyboardVariant;
        };
      };
    };
  };

  systemd.services.display-manager.environment = let
    vars = import ../../hosts/${host}/variables.nix;
    keyboardLayout = vars.keyboardLayout or "us";
    keyboardVariant = vars.keyboardVariant or "";
  in ({XKB_DEFAULT_LAYOUT = keyboardLayout;}
    // lib.optionalAttrs (keyboardVariant != "") {XKB_DEFAULT_VARIANT = keyboardVariant;});

  environment.systemPackages = [sddm-astronaut];

  systemd.tmpfiles.rules = [
    "d /var/lib/AccountsService/icons 0775 root root -"
    # Link your image where SDDM expects it
    "L+ /var/lib/AccountsService/icons/${username} - - - - ${../home/hyprland/face.jpg}"
  ];
}
