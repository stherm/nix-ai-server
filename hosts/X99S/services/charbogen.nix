{ config, ... }:

{
  services.charbogen = {

    enable = true;
    port = 6823;
    domain = "www.role-dice.org";

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

  services.nginx.virtualHosts."${config.services.charbogen.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.charbogen.port}";
      proxyWebsockets = true;
    };
  };
}
