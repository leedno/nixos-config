{
  config,
  pkgs,
  ...
}: let
  gemini-launcher = pkgs.writeShellScriptBin "gemini-launcher" ''
    #!${pkgs.bash}/bin/bash

    KEY_FILE="/run/secrets/gemini_api_key"

    if [ -f "$KEY_FILE" ]; then
      export GEMINI_API_KEY=$(cat "$KEY_FILE" | tr -d '\n')
      exec ${pkgs.kitty}/bin/kitty -e ${pkgs.gemini-cli}/bin/gemini
    else
      exec ${pkgs.kitty}/bin/kitty -e bash -c "echo 'ERROR: Secret not found at $KEY_FILE'"
    fi
  '';
in {
  home.packages = [
    gemini-launcher
  ];

  xdg.desktopEntries.gemini-cli = {
    name = "Gemini CLI";
    comment = "Launch the Gemini CLI in Kitty terminal";
    icon = "utilities-terminal";
    exec = "gemini-launcher";
    terminal = false;
    type = "Application";
    categories = ["Development" "Utility"];
  };
}
