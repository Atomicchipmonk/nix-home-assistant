{ config, pkgs, ... }:

{
    environment.systemPackages  = with pkgs; [
      lm_sensors
      htop
      nmap
      vscode
      git
    ];
}

