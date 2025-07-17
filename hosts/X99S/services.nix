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
    # inputs.core.nixosModules.open-webui
    inputs.core.nixosModules.openssh

    # outputs.nixosModules.open-webui-oci
  ];

  services = {
    nginx = {
      enable = true;
      virtualHosts."ollama.steffen.fail" = {
        # basicAuthFile = config.sops.secrets."ollama/basic-auth".path; # TODO: replace with bearer token auth  via authelia
      };
    };

    ollama = {
      enable = true;
      loadModels = [
        "deepseek-r1:14b"
        "gemma3:12b"
        "gemma3:27b"
        "gemma3:27b-it-qat"
        "mistral:7b"
        "qwen3:14b"
      ];
    };

    open-webui = {
      # enable = true; # FIXME: rapidocr-onnxruntime-1.4.4 fails to build with exit code 134
      package = pkgs.stable.open-webui;
    };
  };

  # Generate secrets with: nix-shell -p apacheHttpd --run 'htpasswd -B -n USERNAME'
  sops =
    let
      owner = "nginx";
      group = "nginx";
      mode = "0440";
    in
    {
      secrets."ollama/basic-auth" = {
        inherit owner group mode;
      };
    };
}
