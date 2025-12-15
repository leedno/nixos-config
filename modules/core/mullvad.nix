{
  pkgs,
  config,
  ...
}: {
  # 1. Enable the Mullvad systemd service
  # This sets up the Mullvad daemon that manages the VPN connection and firewall.
  services.mullvad-vpn.enable = true;

  # 2. Install the Mullvad GUI application for easy management
  # This makes the Mullvad app available in your application launcher.
  environment.systemPackages = [
    pkgs.mullvad-vpn
  ];

  # Optional: Configure the daemon package
  # services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Optional: Enable systemd-resolved for better DNS integration
  # (Mullvad often works better when this is enabled)
  services.resolved.enable = true;
}
