{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # -- CLI Workflow Tools --
    lf
    tmux
  ];
}
