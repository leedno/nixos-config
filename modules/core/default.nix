{
  inputs,
  host,
  ...
}: let
  # Import the host-specific variables.nix
  vars = import ../../hosts/${host}/variables.nix;
in {
  imports = [
    ./system/boot.nix
    ./programs/flatpak.nix
    ./system/fonts.nix
    ./hardware/hardware.nix
    ./system/network.nix
    #./services/mullvad.nix
    ./services/nfs.nix
    ./programs/nh.nix
    ./services/quickshell.nix
    ./system/packages.nix
    ./services/printing.nix
    ./services/postgresql.nix
    # Conditionally import the display manager module
    (
      if vars.displayManager == "tui"
      then ./services/ly.nix
      else ./services/sddm.nix
    )
    ./system/security.nix
    ./services/services.nix
    ./system/secrets.nix
    ./programs/steam.nix
    ./system/stylix.nix
    ./services/syncthing.nix
    ./system/system.nix
    ./programs/thunar.nix
    ./system/user.nix
    ./services/virtualisation.nix
    ./services/xserver.nix
    ./system/cachix.nix
    inputs.stylix.nixosModules.stylix
  ];
}
