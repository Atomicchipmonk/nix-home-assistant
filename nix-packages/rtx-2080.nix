{ config, pkgs, ... }:

{
  # Enable proprietary NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  
  # NVIDIA driver configuration
  hardware.nvidia = {
    # Use the production branch driver (recommended for most use cases)
    # For the latest features, you could use "beta" instead
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Modesetting is required for most wayland compositors
    modesetting.enable = true;
    
    # Enable power management (optional but recommended)
    powerManagement.enable = true;
    
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

  # Enable CUDA support system-wide
  nixpkgs.config = {
    cudaSupport = true;
    cudaCapabilities = [ "7.5" ];
  };
}