{host, ...}: let
  vars = import ../../hosts/${host}/variables.nix;
  inherit
    (vars)
    alacrittyEnable
    tmuxEnable
    vscodeEnable
    antigravityEnable
    ;
  # Select bar module based on barChoice
  barModule = ./noctalia.nix;
in {
  home.file."Pictures/wallpapers" = {
    source = ../../wallpapers;
    recursive = true;
  };
  imports =
    [
      ./amfora.nix
      ./bash.nix
      ./bashrc-personal.nix
      ./overview.nix
      ./python.nix
      ./cli/bat.nix
      ./cli/btop.nix
      ./cli/bottom.nix
      ./cli/cava.nix
      ./emoji.nix
      ./eza.nix
      ./fastfetch
      ./cli/fzf.nix
      ./cli/gh.nix
      ./cli/git.nix
      ./gtk.nix
      ./cli/htop.nix
      ./hyprland
      ./terminals/kitty.nix
      ./cli/lazygit.nix
      ./obs-studio.nix
      #./editors/nvf.nix
      ./editors/nixvim.nix
      ./editors/nano.nix
      ./rofi
      ./qt.nix
      ./scripts
      ./scripts/gemini-cli.nix
      ./stylix.nix
      ./swappy.nix
      ./swaync.nix
      ./tealdeer.nix
      ./virtmanager.nix
      barModule
      ./wlogout
      ./xdg.nix
      ./yazi
      ./zen-browser.nix
      ./zoxide.nix
      ./zsh
    ]
    ++ (
      if vscodeEnable
      then [./editors/vscode.nix]
      else []
    )
    ++ (
      if antigravityEnable
      then [./editors/antigravity.nix]
      else []
    )
    ++ (
      if tmuxEnable
      then [./terminals/tmux.nix]
      else []
    )
    ++ (
      if alacrittyEnable
      then [./terminals/alacritty.nix]
      else []
    );
}
