{
  profile,
  pkgs,
  lib,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = ["main" "brackets" "pattern" "regexp" "root" "line"];
    };
    historySubstringSearch.enable = true;
    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };
    oh-my-zsh = {
      enable = true;
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    initExtra = ''
      # 1. Export Gemini Key from the system secret file
      if [ -f "/run/secrets/gemini_api_key" ];
      then
        export GEMINI_API_KEY=$(cat "/run/secrets/gemini_api_key" | tr -d '\n')
      fi

      # 2. Keybindings and Personal Config
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
      v = "nvim";
      c = "clear";
      fr = "nh os switch --hostname ${profile}";
      up = "cd $HOME/leonos && git pull && nh os switch --hostname ${profile}";
      fu = "nh os switch --hostname ${profile} --update";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cat = "bat";
      man = "batman";
      ts = "tmux new-session -A -s main";
      zg = "lazygit -p $(zoxide query -i)";
    };
  };
}
