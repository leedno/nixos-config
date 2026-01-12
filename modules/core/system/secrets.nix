{
  pkgs,
  username,
  config,
  ...
}: {
  sops = {
    # Point to the secrets file relative to this module
    defaultSopsFile = ../../../secrets/gemini.yaml;
    defaultSopsFormat = "yaml";

    # Use the host's SSH key for decryption (Standard NixOS path)
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    # Decrypt the key and give your user permission
    secrets.gemini_api_key = {
      owner = username; # Uses the 'leon' variable from your flake
    };
  };
}
