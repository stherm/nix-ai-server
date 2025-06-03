{ config, pkgs, lib, ... }:

let
  pgDataDir = "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
  domain   = config.networking.domain;
  hostname = config.networking.hostName;
  fqdn     = "${hostname}.${domain}";
in
{
  systemd.services.postgresql-cert-generator = {
    description = "PostgreSQL Certificate Generator";
    wantedBy    = [ "postgresql.service" ];
    after       = [ "postgresql.service" ];
    path        = with pkgs; [ openssl coreutils ];
    script      = ''
      CERT_FILE="${pgDataDir}/server.crt"
      KEY_FILE="${pgDataDir}/server.key"
      NEEDS_NEW=0
      if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
        NEEDS_NEW=1
      else
        EXPIRES=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d= -f2)
        EXPIRES_SECONDS=$(date -d "$EXPIRES" +%s)
        NOW_SECONDS=$(date +%s)
        THIRTY_DAYS_SECONDS=$((30 * 24 * 60 * 60))
        if [ $((EXPIRES_SECONDS - NOW_SECONDS)) -lt $THIRTY_DAYS_SECONDS ]; then
          NEEDS_NEW=1
        fi
      fi
      if [ "$NEEDS_NEW" -eq 1 ]; then
        mkdir -p "${pgDataDir}"
        cd "${pgDataDir}" || exit 1
        openssl req -new -x509 -days 365 -nodes -text \
          -out server.crt \
          -keyout server.key \
          -subj "/CN=${fqdn}"
        chmod 600 server.key
        chmod 644 server.crt
        chown postgres:postgres server.key server.crt
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers.postgresql-cert-generator = {
    wantedBy    = [ "timers.target" ];
    timerConfig = {
      OnCalendar         = "monthly";
      Persistent         = true;
      RandomizedDelaySec = "12h";
    };
  };

  services.postgresql = {
    enable           = true;
    package          = pkgs.postgresql_16;
    dataDir          = "/var/lib/postgresql/16";
    enableTCPIP      = true;
    settings.port    = 5432;
    ensureDatabases  = [ "fw_grafschaft" ];
    settings         = { ssl = true; };
    authentication   = lib.mkOverride 10 ''
      local all       all                trust
      hostssl all     prosinsky     0.0.0.0/0   scram-sha-256
      hostssl all     prosinsky     ::/0        scram-sha-256
      hostssl all     postgres      0.0.0.0/0   scram-sha-256
      hostssl all     postgres      ::/0        scram-sha-256
      hostssl fw_grafschaft all  0.0.0.0/0   scram-sha-256
      hostssl fw_grafschaft all  ::/0        scram-sha-256
    '';
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];
  users.users.postgres.extraGroups      = [ "nginx" ];
}

