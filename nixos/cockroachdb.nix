{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = {
    cache = "25%";
    certsDir = null;
    enable = true;
    extraArgs = [];
    group = "cockroachdb";
    http = {
      address = "localhost";
      port = 8105;
    };
    insecure = true;
    join = null;
    listen = {
      address = "localhost";
      port = 26257;
    };
    locality = null;
    maxSqlMemory = "25%";
    openPorts = false;
    package = pkgs.cockroachdb-bin;
    user = "cockroachdb";
  };
  crdb = cfg.package;

  startupCommand = utils.escapeSystemdExecArgs
    ([
      # Basic startup
      "${crdb}/bin/cockroachdb"
      "start-single-node"
      "--logtostderr"
      "--store=/var/lib/cockroachdb"

      # WebUI settings
      "--http-addr=${cfg.http.address}:${toString cfg.http.port}"

      # Cluster listen address
      "--listen-addr=${cfg.listen.address}:${toString cfg.listen.port}"

      # Cache and memory settings.
      "--cache=${cfg.cache}"
      "--max-sql-memory=${cfg.maxSqlMemory}"

      # Certificate/security settings.
      (if cfg.insecure then "--insecure" else "--certs-dir=${cfg.certsDir}")
    ]
    ++ lib.optional (cfg.join != null) "--join=${cfg.join}"
    ++ lib.optional (cfg.locality != null) "--locality=${cfg.locality}"
    ++ cfg.extraArgs);

in

{
    assertions = [
      { assertion = !cfg.insecure -> cfg.certsDir != null;
        message = "CockroachDB must have a set of SSL certificates (.certsDir), or run in Insecure Mode (.insecure = true)";
      }
    ];

    environment.systemPackages = [ crdb ];

    users.users = optionalAttrs (cfg.user == "cockroachdb") {
      cockroachdb = {
        description = "CockroachDB Server User";
        uid         = config.ids.uids.cockroachdb;
        group       = cfg.group;
      };
    };

    users.groups = optionalAttrs (cfg.group == "cockroachdb") {
      cockroachdb.gid = config.ids.gids.cockroachdb;
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openPorts
      [ cfg.http.port cfg.listen.port ];

    systemd.services.cockroachdb =
      { description   = "CockroachDB Server";
        documentation = [ "man:cockroach(1)" "https://www.cockroachlabs.com" ];

        after    = [ "network.target" "time-sync.target" ];
        requires = [ "time-sync.target" ];
        wantedBy = lib.mkForce [ ];

        unitConfig.RequiresMountsFor = "/var/lib/cockroachdb";

        serviceConfig =
          { ExecStart = startupCommand;
            Type = "notify";
            User = cfg.user;
            Restart = "always";
            # A conservative-ish timeout is alright here, because for Type=notify
            # cockroach will send systemd pings during startup to keep it alive
            TimeoutStopSec = 300;
            RestartSec = 10;
            WorkingDirectory = "/var/lib/cockroachdb";
            StandardOutput = "syslog";
            StandardError = "syslog";
            SyslogIdentifier = cfg.user;
            NotifyAccess = "all";
          };
      };
  }
