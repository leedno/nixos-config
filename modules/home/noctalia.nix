{
  inputs,
  pkgs,
  lib,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  noctaliaPath = inputs.noctalia.packages.${system}.default;
  configDir = "${noctaliaPath}/share/noctalia-shell";
in {
  # 1. Install the package
  home.packages = [noctaliaPath];

  # 2. REMOVED: xdg.configFile block is gone.
  # This "unlocks" the file so the UI can save changes.

  # 3. Seed the shell code AND a starter config
  home.activation.seedNoctalia = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -eu
    # Path for the shell logic
    DEST_SHELL="$HOME/.config/quickshell/noctalia-shell"
    # Path for the settings file
    DEST_CONF="$HOME/.config/noctalia/settings.json"

    # Copy shell code if missing (Basic stuff works)
    if [ ! -d "$DEST_SHELL" ]; then
      mkdir -p "$HOME/.config/quickshell"
      cp -R "${configDir}" "$DEST_SHELL"
      chmod -R u+rwX "$DEST_SHELL"
    fi

    # Create a basic settings file ONLY if it doesn't exist
    if [ ! -f "$DEST_CONF" ]; then
      mkdir -p "$HOME/.config/noctalia"
      # This provides a minimal working JSON so the bar isn't broken on first boot
      echo '{"dock": {"enabled": false}}' > "$DEST_CONF"
      chmod u+rw "$DEST_CONF"
    fi
  '';
}
