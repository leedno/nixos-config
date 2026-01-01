{host, ...}: let
  vars = import ../../../hosts/${host}/variables.nix;
in {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # 1. Clipboard History (Requires pkgs.cliphist)
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"

      # 2. System Environment
      "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user start hyprpolkitagent"
      "pypr &"

      # 3. Noctalia Shell (Clean start using Local Config)
      # We kill old bars and launch the local, writable version of Noctalia
      "killall -q waybar; pkill waybar; killall -q swaync; pkill swaync"
      "quickshell -p $HOME/.config/quickshell/noctalia-shell"
    ];
  };
}
