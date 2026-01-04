{ config, pkgs, libs, utils, ... }:

let
  fixedWebrtc = pkgs.webrtc-audio-processing_1.overrideAttrs (oldAttrs: {
    stdenv = pkgs.gcc13Stdenv;
    # postPatch = (oldAttrs.postPatch or "") + ''
    #   sed -i '/#include "rtc_base\/thread_annotations.h"/a #include <cstdint>' \
    #     webrtc-audio-processing-1/api/task_queue/task_queue_base.h
    # '';
  });
in
{
  nixpkgs.overlays = [
    (final: prev: {
      wyoming-openwakeword = prev.wyoming-openwakeword.override {
        webrtc-audio-processing_1 = fixedWebrtc;
      };
    })
  ];


  # nixpkgs.overlays = [
  #   (final: prev: {
  #     python313 = prev.python313.override {
  #       packageOverrides = pyfinal: pyprev: {
  #         webrtc-audio-processing_1 = prev.webrtc-audio-processing_1.override {
  #           stdenv = prev.gcc13Stdenv;
  #         }; 
  #       };
  #     };
  #   })
  # ];
  
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