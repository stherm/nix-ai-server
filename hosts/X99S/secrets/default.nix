{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.defaultSopsFile = ./secrets.yaml; # HOTFIX

  sops.secrets."github-runners/nix-ai-server/token" = { };

  sops.secrets."charbogen/user_credentials" = { owner = "charbogen"; };
  sops.secrets."charbogen/db_credentials" = { owner = "charbogen"; };
  sops.secrets."charbogen/db_uri" = { owner = "charbogen"; };
  sops.secrets."charbogen/flask_secret" = { owner = "charbogen"; };
}
