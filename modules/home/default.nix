{
  host,
  pkgs,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
  inherit
    (vars)
    alacrittyEnable
    tmuxEnable
    vscodeEnable
    antigravityEnable
    obsEnable
    zenEnable
    ;

  barModule = ./desktop/noctalia.nix;
in {
  home.file."Pictures/Wallpapers" = {
    source = ../../wallpapers;
    recursive = true;
  };

  home.file.".face".source = ./desktop/hyprland/animations/face.jpg;
  home.file.".face.icon".source = ./desktop/hyprland/animations/face.jpg;

  imports =
    [
      ./programs/amfora.nix
      ./cli/bash.nix
      ./cli/bashrc-personal.nix
      ./system/overview.nix
      ./system/python.nix
      ./cli/bat.nix
      ./cli/btop.nix
      ./cli/bottom.nix
      ./cli/cava.nix

      #./emoji.nix # Removed for optimization
      ./cli/eza.nix
      ./cli/direnv.nix
      ./cli/fastfetch
      ./cli/fzf.nix
      ./cli/gh.nix
      ./cli/git.nix
      ./desktop/gtk.nix
      ./cli/htop.nix
      ./desktop/hyprland
      ./terminals/kitty.nix
      ./cli/lazygit.nix
      ./editors/nvf.nix

      ./editors/nano.nix
      ./desktop/rofi
      ./desktop/qt.nix
      ./scripts
      ./scripts/gemini-cli.nix
      ./system/stylix.nix
      ./desktop/swappy.nix
      ./desktop/swaync.nix
      ./cli/tealdeer.nix
      ./programs/virtmanager.nix
      barModule
      ./desktop/wlogout
      ./system/xdg.nix
      ./cli/yazi
      ./cli/zoxide.nix
      ./cli/zsh
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
      if obsEnable
      then [./programs/obs-studio.nix]
      else []
    )
    ++ (
      if zenEnable
      then [./programs/zen-browser.nix]
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

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    VISUAL = "${pkgs.neovim}/bin/nvim";
  };
}
