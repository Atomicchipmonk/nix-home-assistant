{
    ### Home assistant central + secondary gaming rig

    imports = [
        ./nix-packages/home-assistant.nix
        ./nix-packages/dev-tools.nix
        ./nix-packages/gaming.nix
        ./nix-packages/rtx-2080.nix
        ./nix-packages/satellite.nix
    ];


    # Turn off all the suspend possibilities
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

}