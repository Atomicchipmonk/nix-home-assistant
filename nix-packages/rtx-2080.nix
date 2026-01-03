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
    # Legacy driver to handle AMD 1700
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    
    # Modesetting is required for most wayland compositors
    modesetting.enable = true;
    
    # Disable power management (possibly helpful with crashes)
    powerManagement.enable = false;
    
    # Keep the card powered during sleep/suspend (can help with stability)
    powerManagement.finegrained = false;
    
    # Enable the open-source kernel module (not available for RTX 2080)
    # The RTX 2080 (Turing) requires the proprietary driver
    open = false;

    nvidiaPersistenced = true;
  };



  boot.kernelPackages = pkgs.linuxPackages_latest;
  ## Possible downgrade: boot.kernelPackages = pkgs.linuxPackages_6_1;  # LTS kernel
  
  boot.kernelParams = [
    # CRITICAL: Disable C-states completely on Ryzen 1700
    "processor.max_cstate=1"
    "idle=poll"
    
    # Disable problematic AMD idle driver
    "amd_idle.max_cstate=0"
    
    # Ryzen-specific fixes
    "rcu_nocbs=0-15"  # Offload RCU from all CPUs
    "nohz_full=1-15"  # Reduce timer interrupts on all but CPU 0
    
    # NVIDIA driver fixes
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_EnableMSI=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=0"
    "nvidia.NVreg_UsePageAttributeTable=1"
    
    # Disable SRSO mitigation (it's broken anyway on Ryzen 1700)
    "spec_rstack_overflow=off"
    "nospectre_v2"  # Ryzen 1700 mitigations cause more problems than they solve
    
    # # PCIe fixes for first-gen Ryzen
    # "pcie_aspm=off"  # ASPM causes issues with Ryzen 1000
    # "pci=nomsi"  # If MSI still causes issues, try this instead
  ];
  
  
  
  hardware.cpu.amd.updateMicrocode = true;
  
  # Disable CPU frequency scaling - causes issues on Ryzen 1700
  powerManagement.cpuFreqGovernor = "performance";
  
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