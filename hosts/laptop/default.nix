# profiles/laptop/default.nix
{host, ...}: {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];

  # Enable GPU Drivers - Setting for AMD Integrated Graphics
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime.enable = false;
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
}
