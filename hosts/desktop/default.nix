{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ../../modules/shared-packages.nix
  ];
}
