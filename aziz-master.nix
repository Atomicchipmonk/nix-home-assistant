{ pkgs, ... }:

{
    ### Master Bedroom wyoming sattelite + monitor

    ### Prior setup required
    # In configuration.nix 
    #   add your user
    #   enable ssh
    #   add git either through nix-shell or system
    #   set hostname
    # add nix-channel
    # `sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware`
    # `sudo nix-channel --update`


    imports = [
        <nixos-hardware/raspberry-pi/4>
        ./nix-packages/satellite.nix
    ];

    # satellite area set
    services.wyoming.satellite.area = "master";

    environment.systemPackages = with pkgs; [
        vlc
        git
    ];


    ###### Hardware Setup - Touch screen Raspi 4 ####### 

    ### GPU ###
    hardware.raspberry-pi."4".fkms-3d.enable = true;

    ### Audio ###
    boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" "snd_bcm2835.enable_headphones=1" ];

    ### Display ###

    # Enable the X11 windowing system, 
    services.xserver = {
        enable = true;

        # Configure keymap in X11
        xkb.layout = "us";
        xkb.variant = "";

        # Turn off auto lock
        xautolock.enable = false; 

    };

    # GNOME Desktop Environment
    services.desktopManager.gnome.enable = true;

    services.displayManager = {
        # GNOME Desktop Environment
        gdm.enable = true;

        autoLogin.enable = true;
        autoLogin.user = "chris";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # If no user is logged in, the machine will power down after 20 minutes.
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    #Pin to 6.12 for now
    boot.kernelPackages = pkgs.linuxPackages_6_12

}