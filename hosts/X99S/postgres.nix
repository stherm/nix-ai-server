{
  config,
  pkgs,
  lib,
  ...
}:

let
  pgDataDir = "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
  domain = config.networking.domain;
  hostname = config.networking.hostName;
  fqdn = "${hostname}.${domain}";
in
{
  systemd.services.postgresql-cert-generator = {
    description = "PostgreSQL Certificate Generator";
    wantedBy = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
    path = with pkgs; [
      openssl
      coreutils
    ];
    script = ''
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
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
      RandomizedDelaySec = "12h";
    };
  };

  services.pgadmin = {
    enable = true;
    initialEmail = "steffen@portuus.de";
    initialPasswordFile = "/home/steffen/pgpass";
  };

  services.nginx.virtualHosts."sql.steffen.fail" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:5050";
      proxyWebsockets = true;
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/var/lib/postgresql/16";
    enableTCPIP = true;
    settings.port = 5432;
    ensureDatabases = [
      "fw_grafschaft"
      "pnp"
    ];
    settings = {
      ssl = true;
    };
    ensureUsers = [
      {
        name = "tobi";
        ensureClauses = {
          login = true;
          superuser = true;
        };
      }
      {
        name = "steffen";
        ensureClauses = {
          login = true;
          superuser = true;
        };
      }
      {
        name = "prosinsky";
        ensureClauses = {
          login = true;
          superuser = true;
        };
      }
      {
        name = "pnp";
        ensureClauses = {
          login = true;
        };
        ensureDBOwnership = true;
      }
      {
        name = "fw_grafschaft";
        ensureClauses = {
          login = true;
        };
      }
    ];
    authentication = lib.mkOverride 10 ''
      local all       all                trust
      # Zugriffe für fw_grafschaft
      hostssl fw_grafschaft prosinsky     0.0.0.0/0   scram-sha-256
      hostssl fw_grafschaft prosinsky     ::/0        scram-sha-256
      hostssl fw_grafschaft postgres      0.0.0.0/0   scram-sha-256
      hostssl fw_grafschaft postgres      ::/0        scram-sha-256

      # Zugriffe für pnp
      hostssl pnp     tobi          0.0.0.0/0   scram-sha-256
      hostssl pnp     tobi          ::/0        scram-sha-256
      hostssl pnp     steffen       0.0.0.0/0   scram-sha-256
      hostssl pnp     steffen       ::/0        scram-sha-256
      hostssl pnp     postgres      0.0.0.0/0   scram-sha-256
      hostssl pnp     postgres      ::/0        scram-sha-256
      hostssl pnp     pnp      0.0.0.0/0        scram-sha-256
      hostssl pnp     pnp      ::/0        scram-sha-256
    '';
  };
  networking.firewall.allowedTCPPorts = [ 5432 ];
  users.users.postgres.extraGroups = [ "nginx" ];
}
