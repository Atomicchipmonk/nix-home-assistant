{ config, pkgs, libs, utils, ... }:

{

  environment.systemPackages  = with pkgs; [
      alsa-utils
    ];

  services.wyoming.satellite = {
    enable = true;
    uri = "tcp://0.0.0.0:10700";
    area = "brickhouse";
    user = "chris";
    microphone = {
      command = "arecord -r 16000 -c 1 -f S16_LE -t raw";
    };
    sound = {
      command = "aplay -r 22050 -c 1 -f S16_LE -t raw";
    };
    vad.enable = false;

  };



}