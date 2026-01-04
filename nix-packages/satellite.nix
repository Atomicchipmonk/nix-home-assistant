{ config, pkgs, libs, utils, ... }:

{

  nixpkgs.overlays = [
    (final: prev: {
      python313 = prev.python313.override {
        packageOverrides = pyfinal: pyprev: {
          webrtc-audio-processing_1 = prev.webrtc-audio-processing_1.override {
            stdenv = prev.gcc13Stdenv;
          }; 
        }
      }
    })
  ];
  
  environment.systemPackages  = with pkgs; [
      alsa-utils
    ];

  services.wyoming.satellite = {
    enable = true;
    uri = "tcp://0.0.0.0:10700";
    #Require area to be set somewhere else
    #area = "master";
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