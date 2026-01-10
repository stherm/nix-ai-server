{ config, lib, ... }:

{
  options.services.charbogen.nginx = lib.mkOption {
    type = lib.types.submodule {
      options.enable = lib.mkEnableOption "nginx";
    };
    default = { enable = true; };
    description = "HOTFIX: Define missing nginx option from upstream module";
  };

  config = {
    services.charbogen = {
      enable = true;
      port = 5000;
      domain = "www.roll-dice.org";
      nginx.enable = true;

      secretKeyFile = config.sops.secrets."charbogen_flask_secret".path;
      dbUriFile = config.sops.secrets."charbogen_db_uri".path;
      dbCredentialsFile = config.sops.secrets."charbogen_db_creds".path;
      userCredentialsFile = config.sops.secrets."charbogen_user_creds".path;
    };

    sops.secrets = {
      "charbogen_user_creds" = { owner = "charbogen"; key = "charbogen/user_credentials"; };
      "charbogen_db_creds" = { owner = "charbogen"; key = "charbogen/db_credentials"; };
      "charbogen_db_uri" = { owner = "charbogen"; key = "charbogen/db_uri"; };
      "charbogen_flask_secret" = { owner = "charbogen"; key = "charbogen/flask_secret"; };
    };
  };
}
