{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ../../modules/shared-packages.nix
  ];

  # --- Kernel Optimizations ---
  boot.kernel.sysctl = {
    # 10 means "Don't swap until RAM is 90% full"
    "vm.swappiness" = 10;
    # Helps the UI stay snappy by keeping file/folder metadata in RAM longer
    "vm.vfs_cache_pressure" = 50;
  };

  # --- Physical Swap File (SSD) ---
  # This acts as the final safety net.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8GB
      priority = 0; # Only used if zRAM is totally full
    }
  ];

  # --- zRAM (Compressed RAM) ---
  # This turns part of your 8GB into a high-speed compressed zone.
  zramSwap = {
    enable = true;
    algorithm = "lz4"; # Lowest CPU impact for gaming
    memoryPercent = 50; # Use up to 4GB of your RAM for compression
    priority = 100; # High priority: Use this FIRST
  };

  programs.zsh.shellAliases = {
    flush = "sudo swapoff -a && sudo swapon -a && echo 'Swap Flushed!'";
    stats = "zramctl && echo '---' && swapon --show";
  };
}
