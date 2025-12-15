{host, ...}: {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];

  # Configure drivers for the laptop
  # Example: Standard Intel Laptop
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = false; # Set to true if you have a discrete GPU
  drivers.nvidia-prime.enable = false; # Set to true for Hybrid Nvidia
  drivers.intel.enable = true;

  vm.guest-services.enable = false;
}
