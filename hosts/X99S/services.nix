{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.ollama
    inputs.core.nixosModules.openssh

  ];

  services = {
    #  nginx = {
    #    enable = false;
    #    virtualHosts."ollama.steffen.fail" = {
    # basicAuthFile = config.sops.secrets."ollama/basic-auth".path; # TODO: replace with bearer token auth  via authelia
    #    };

    ollama = {
      enable = false;
      loadModels = [
        "deepseek-r1:14b"
        "gemma3:12b"
        "gemma3:27b"
        "gemma3:27b-it-qat"
        "gpt-oss:20b"
        "mistral:7b"
        "qwen3:14b"
      ];
    };
  };

  # Generate secrets with: nix-shell -p apacheHttpd --run 'htpasswd -B -n USERNAME'
  #sops =
  # let
  #    owner = "nginx";
  #    group = "nginx";
  #    mode = "0440";
  #  in
  #  {
  #    secrets."ollama/basic-auth" = {
  #      inherit owner group mode;
  #    };
  #  };
}
