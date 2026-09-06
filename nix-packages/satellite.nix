{ config, pkgs, lib, utils, ... }:


{
  
  environment.systemPackages  = with pkgs; [
      alsa-utils
    ];

  networking.firewall.allowedTCPPorts = [ 10700 ];

  services.wyoming.satellite = {
    enable = true;
    uri = "tcp://0.0.0.0:10700";
    #Require area to be set somewhere else
    #area = "master";
    user = "chris";
    microphone = {
      command = "arecord -r 16000 -c 1 -f S16_LE -t raw --latency-msec=50";
    };
    sound = {
      command = "aplay -r 22050 -c 1 -f S16_LE -t raw --latency-msec=50";
    };

    # still no dice on vap due to chunk size issue (), this just constantly streams mic data
    vad.enable = false;

  };



}