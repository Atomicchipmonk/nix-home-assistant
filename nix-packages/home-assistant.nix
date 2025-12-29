{ config, pkgs, libs, utils, ... }:

{

  # environment.systemPackages  = with pkgs; [
  #     wyoming-satellite
  #     alsa-utils
  #   ];


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
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
      automation = [
        {
          alias = "Toggle Announcement";
          triggers = [
            {
              trigger = {
                platform = "numeric_state";
                entity_id = "input_boolean.toggle";
                to = "on";
              };
            }
          ]; 
          condition = [];
          actions = [
            {
              action = {
                target = {
                  entity_id = "conversation.home_assistant";
                  data = {
                      message = "Turned Toggle On";
                      preannounce = true;
                  };
                  
                };
              };
            }
          ]; 
        }
      ];
    };
  };


  services.wyoming.piper.servers.options = {
    enable = true;
    voice = "en_US-lessac-high";
    uri = "tcp://0.0.0.0:10200";
  };

  services.wyoming.faster-whisper.servers.options = {
    enable = true;
    language = "en";
    model = "distil-medium.en";
    uri = "tcp://0.0.0.0:10300";
  };

  services.wyoming.openwakeword = {
    enable = true;
    uri = "tcp://0.0.0.0:10400";

  };

}
