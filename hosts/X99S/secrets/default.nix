{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.defaultSopsFile = ./secrets.yaml; # HOTFIX

  sops.secrets."github-runners/nix-ai-server/token" = { };

  sops.secrets."charbogen_user_creds" = { owner = "charbogen"; };
  sops.secrets."charbogen_db_creds" = { owner = "charbogen"; };
  sops.secrets."charbogen_db_uri" = { owner = "charbogen"; };
  sops.secrets."charbogen_flask_secret" = { owner = "charbogen"; };
}
