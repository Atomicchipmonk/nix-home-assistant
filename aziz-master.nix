{
    ### Master Bedroom wyoming sattelite + monitor

    imports = [
        <nixos-hardware/raspberry-pi/4>
        ./nix-packages/satellite.nix
    ];

    environment.systemPackages = with pkgs; [
        vlc
    ];


    ###### Hardware Setup - Touch screen Raspi 4 ####### 

    ### Audio ###
    boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" "snd_bcm2835.enable_headphones=1" ];

    ### Display ###

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # If no user is logged in, the machine will power down after 20 minutes.
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    services.displayManager = {
        autoLogin.enable = true;
        autoLogin.user = "heisty";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;
}