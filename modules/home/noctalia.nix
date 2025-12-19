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
  # 1. Install the package manually
  home.packages = [noctaliaPath];

  # 2. Configure Settings declaratively
  # This writes the settings file directly.
  # NOTE: This makes ~/.config/noctalia/settings.json read-only.
  xdg.configFile."noctalia/settings.json".text = builtins.toJSON {
    dock = {
      enabled = false;
    };
  };

  # 3. Seed the shell code (Keep this as it was)
  home.activation.seedNoctaliaShellCode = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -eu
    DEST="$HOME/.config/quickshell/noctalia-shell"
    SRC="${configDir}"

    if [ ! -d "$DEST" ]; then
      mkdir -p "$HOME/.config/quickshell"
      cp -R "$SRC" "$DEST"
      chmod -R u+rwX "$DEST"
    fi
  '';
}
