{
  pkgs,
  config,
  ...
}: {
  # 1. Enable the Mullvad systemd service
  services.mullvad-vpn.enable = true;

  # 2. Install the Mullvad GUI application
  environment.systemPackages = [
    pkgs.mullvad-vpn
  ];

  # 3. Enable systemd-resolved for better DNS integration
  services.resolved.enable = true;

  # 4. Automatically enable VPN connection on daemon startup (without GUI)
  systemd.services.mullvad-daemon = {
    postStart = ''
      # Wait for the daemon to be ready before sending commands
      while ! ${pkgs.mullvad-vpn}/bin/mullvad status >/dev/null 2>&1; do
        sleep 1
      done
      ${pkgs.mullvad-vpn}/bin/mullvad auto-connect set on
    '';
  };
}
