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
}
