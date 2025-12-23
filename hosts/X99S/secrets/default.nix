{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.defaultSopsFile = ./secrets.yaml; # HOTFIX

  # sops.secrets."github-runners/nix-ai-server/token" = { };
}
