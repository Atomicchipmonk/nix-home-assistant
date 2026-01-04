{ config, pkgs, libs, utils, ... }:

{

  nixpkgs.overlays = [
    (final: prev: {
      webrtc-audio-processing_1 = prev.webrtc-audio-processing_1.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          # Add missing cstdint include
          sed -i '17a #include <cstdint>' webrtc-audio-processing-1/api/task_queue/task_queue_base.h
        '';
      });
    })
  ];
  
  environment.systemPackages  = with pkgs; [
      alsa-utils
    ];

  services.wyoming.satellite = {
    enable = true;
    uri = "tcp://0.0.0.0:10700";
    area = "master";
    user = "chris";
    microphone = {
      command = "arecord -r 16000 -c 1 -f S16_LE -t raw";
    };
    sound = {
      command = "aplay -r 22050 -c 1 -f S16_LE -t raw";
    };

    # still no dice on vap due to chunk size issue (), this just constantly streams mic data
    vad.enable = false;

  };



}