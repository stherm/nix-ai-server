{ config, ... }:

{
  services.charbogen = {

    enable = true;
    port = 6823;
    domain = "www.role-dice.org";

    secretKeyFile = config.sops.secrets."charbogen/flask_secret".path;
    dbUriFile = config.sops.secrets."charbogen/db_uri".path;
    dbCredentialsFile = config.sops.secrets."charbogen/db_credentials".path;
    userCredentialsFile = config.sops.secrets."charbogen/user_credentials".path;
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
