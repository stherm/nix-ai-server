{ inputs, config, ... }:

{
  imports = [
    inputs.core.nixosModules.nginx
  ];

  services.nginx = {
    enable = true;
    # virtualHosts."ollama.steffen.fail" = {
    #   basicAuthFile = config.sops.secrets."ollama/basic-auth".path; # TODO: replace with bearer token auth via authelia
    # };
  };

  # Generate secrets with: nix-shell -p apacheHttpd --run 'htpasswd -B -n USERNAME'
  # sops =
  #   let
  #     owner = "nginx";
  #     group = "nginx";
  #     mode = "0440";
  #   in
  #   {
  #     secrets."ollama/basic-auth" = {
  #       inherit owner group mode;
  #     };
  #   };
}
