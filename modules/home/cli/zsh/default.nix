{
  profile,
  pkgs,
  lib,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;

    initExtra = lib.mkOrder 100 ''
      # P10k Instant Prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Keybindings and Personal Config
      bindkey "\eh" backward-word
      bindkey "\ej" down-line-or-history
      bindkey "\ek" up-line-or-history
      bindkey "\el" forward-word

      if [ -f $HOME/.zshrc-personal ];
      then
        source $HOME/.zshrc-personal
      fi
    '';

    shellAliases = {
      nix-fmt-all = "nix fmt ./";
      sv = "sudo nvim";
      v = "nvim"; # Clean alias
      c = "clear";
      fr = "nh os switch --hostname ${profile}";
      up = "cd $HOME/leonos && git pull && nh os switch --hostname ${profile}";
      fu = "nh os switch --hostname ${profile} --update";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cat = "bat";
      man = "batman";
      ts = "tmux new-session -A -s main";
      zg = "lazygit -p $(zoxide query -i)";
      flush = "sudo swapoff -a && sudo swapon -a && echo 'Swap Flushed!'";
      stats = "zramctl && echo '---' && swapon --show";
    };
  };
}
