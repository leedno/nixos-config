{
  config,
  pkgs,
  ...
}: let
  gemini-launcher = pkgs.writeShellScriptBin "gemini-launcher" ''
    #!${pkgs.bash}/bin/bash

    # 1. Get the path to the decrypted key from sops-nix config
    KEY_FILE="${config.sops.secrets.gemini_api_key.path}"

    # 2. Check if the decrypted file exists
    if [ -f "$KEY_FILE" ]; then
      # 3. Read the content (the key) and export it as an env var
      # 'tr -d' ensures no accidental newlines are included
      export GEMINI_API_KEY=$(cat "$KEY_FILE" | tr -d '\n')

      # 4. Launch Gemini
      exec ${pkgs.kitty}/bin/kitty -e ${pkgs.gemini-cli}/bin/gemini
    else
      # Error handling if decryption fails
      exec ${pkgs.kitty}/bin/kitty -e bash -c "echo 'ERROR: Sops secret not found at $KEY_FILE'; echo 'Check your secrets/gemini.yaml and .sops.yaml configuration.'; read -p 'Press enter to exit'"
    fi
  '';
in {
  # --- Sops Configuration ---
  # Path to encrypted secrets file
  sops.defaultSopsFile = ../../../secrets/gemini.yaml;

  # Define the specific key to extract from the YAML file
  sops.secrets.gemini_api_key = {};
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  # --------------------------

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
