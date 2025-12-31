{ config, pkgs, libs, utils, ... }:

let 
  modelsLocation = builtins.path { 
    name = "fixed-name"; 
    path = ../models; 
  };
in
{

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "ollama"
      "piper"
      "whisper"
      "wyoming"
      "conversation"
      "isal"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
      
      # "automation ui" = "!include test-automations.yaml";
    };

    ### Configuration is all stored in /var/lib/hass ###

    configWritable = true;

  };


  services.wyoming.piper.servers.options = {
    enable = true;
    voice = "en_US-lessac-high";
    uri = "tcp://0.0.0.0:10200";
  };

  services.wyoming.faster-whisper = {
    servers.options = {
      enable = true;
      language = "en";
      model = "turbo";
      uri = "tcp://0.0.0.0:10300";

      #Assumes CUDA capablity, specifically ctranslate2 (rtx-2080.nix)
      device = "cuda";
    };

  };

  
    services.wyoming.openwakeword = {
      enable = true;
      uri = "tcp://0.0.0.0:10400";
      customModelsDirectories = [ modelsLocation ];
    };

}
