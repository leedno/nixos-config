{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk # <--- Necessary for opening URLs/Logins
    ];
    configPackages = [pkgs.hyprland];

    # Modern NixOS way to ensure portals work for all apps
    config.common.default = "*";
  };

  services = {
    flatpak = {
      enable = true;

      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];

      # List the Flatpak applications you want to install
      packages = [
        #"com.github.tchx84.Flatseal" # Manage flatpak permissions
        #"io.github.flattool.Warehouse" # Manage flatpaks
      ];

      # Automatically update Flatpaks on rebuild
      update.onActivation = true;
    };
  };
}
