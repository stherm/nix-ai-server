# Inhalt für ./postgre.nix
{ config, pkgs, ... }:

let
  pgDataDir = "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
  domain = config.networking.domain;
  hostname = config.networking.hostName;
  fqdn = "${hostname}.${domain}";
in
{
  # PostgreSQL-Zertifikat-Service
  systemd.services.postgresql-cert-generator = {
    description = "PostgreSQL Certificate Generator";
    wantedBy = [ "multi-user.target" ];
    before = [ "postgresql.service" ];
    path = with pkgs; [
      openssl
      coreutils
    ];
    script = ''
      # Prüfen, ob die Zertifikate fehlen oder in den nächsten 30 Tagen ablaufen
      CERT_FILE="${pgDataDir}/server.crt"
      KEY_FILE="${pgDataDir}/server.key"
      NEEDS_NEW=0

      # Erstellen, wenn Dateien nicht existieren
      if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
        NEEDS_NEW=1
      else
        # Ablaufdatum prüfen (30 Tage vorher erneuern)
        EXPIRES=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d= -f2)
        EXPIRES_SECONDS=$(date -d "$EXPIRES" +%s)
        NOW_SECONDS=$(date +%s)
        THIRTY_DAYS_SECONDS=$((30 * 24 * 60 * 60))
        
        if [ $((EXPIRES_SECONDS - NOW_SECONDS)) -lt $THIRTY_DAYS_SECONDS ]; then
          NEEDS_NEW=1
        fi
      fi

      # Zertifikate erstellen/erneuern wenn nötig
      if [ "$NEEDS_NEW" -eq 1 ]; then
        mkdir -p "${pgDataDir}"
        cd "${pgDataDir}" || exit 1
        
        # Zertifikat und Schlüssel erstellen
        openssl req -new -x509 -days 365 -nodes -text \
          -out server.crt \
          -keyout server.key \
          -subj "/CN=${fqdn}"
        
        # Berechtigungen festlegen
        chmod 600 server.key
        chmod 644 server.crt
        chown postgres:postgres server.key server.crt
        
        echo "PostgreSQL certificates generated or renewed"
      else
        echo "PostgreSQL certificates are up to date"
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Timer zum regelmäßigen Überprüfen/Erneuern der Zertifikate
  systemd.timers.postgresql-cert-generator = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly"; # Monatliche Überprüfung
      Persistent = true;
      RandomizedDelaySec = "12h";
    };
  };

  # PostgreSQL Konfiguration
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    settings.port = 5432;
    ensureDatabases = [ "fw_grafschaft" ];
    settings = {
      ssl = true;
      # Standardmäßig sucht PostgreSQL die Zertifikate im PGDATA-Verzeichnis
      # Die Namen 'server.crt' und 'server.key' sind die PostgreSQL-Defaults
    };
    authentication = pkgs.lib.mkOverride 10 ''
      # Lokale Verbindungen mit Trust-Authentifizierung
      local all       all                trust

      # Externe Verbindungen mit Passwort-Authentifizierung und TLS
      hostssl all      prosinsky     0.0.0.0/0   scram-sha-256
      hostssl all      prosinsky     ::/0        scram-sha-256
      hostssl all      postgres      0.0.0.0/0   scram-sha-256
      hostssl all      postgres      ::/0        scram-sha-256
      hostssl fw_grafschaft all      0.0.0.0/0   scram-sha-256
      hostssl fw_grafschaft all      ::/0        scram-sha-256
    '';
  };

  # Stelle sicher, dass das Service-Directory existiert
  systemd.tmpfiles.rules = [
    "d ${pgDataDir} 0700 postgres postgres -"
  ];

  # Füge PostgreSQL-Port zur Firewall hinzu
  networking.firewall.allowedTCPPorts = [ 5432 ];

  # Füge postgres zum nginx-Gruppe hinzu, falls nötig
  users.users.postgres.extraGroups = [ "nginx" ];

  # PostgreSQL-Service-Konfiguration
  systemd.services.postgresql.serviceConfig = {
    User = "postgres";
  };
}
