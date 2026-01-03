{ config, pkgs, ... }:

{

  # Use the public cuda nix cache
  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  nixpkgs =  {
    config = {
      cudaSupport = false;
      allowUnfree = true;
    };

    # Set ctranslate2 cuda support
    overlays = [
      (final: prev: {
        ctranslate2 = prev.ctranslate2.override {
          withCUDA = true;
          withCuDNN = true;
        };
      })
    ];
  };
  
  # Enable proprietary NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # NVIDIA driver configuration
  hardware.nvidia = {
    # Use the production branch driver (recommended for most use cases)
    # For the latest features, you could use "beta" instead
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Modesetting is required for most wayland compositors
    modesetting.enable = true;
    
    # Disable power management (possibly helpful with crashes)
    powerManagement.enable = false;
    
    # Keep the card powered during sleep/suspend (can help with stability)
    powerManagement.finegrained = false;
    
    # Enable the open-source kernel module (not available for RTX 2080)
    # The RTX 2080 (Turing) requires the proprietary driver
    open = false;
  };
  
  # Enable OpenGL/Vulkan support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Enable 32-bit support if needed
  };
  
  # Add CUDA toolkit to system packages if you want it available system-wide
  environment.systemPackages = with pkgs; [
    cudatoolkit
  ];

}