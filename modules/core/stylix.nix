{
  pkgs,
  host,
  ...
}: let
  # Import variables
  vars = import ../../hosts/${host}/variables.nix;
in {
  stylix = {
    enable = true;

    # Use the local path defined in variables.nix
    image = vars.stylixImage;

    # Keep your settings (adjust these if your previous file had different fonts/cursor)
    polarity = "dark";
    opacity.terminal = 1.0;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
