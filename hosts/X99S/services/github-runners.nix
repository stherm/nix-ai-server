{ config, ... }:
{
  services.github-runners = {
    nix-ai-server = {
      enable = true;
      url = "https://github.com/stherm/nix-ai-server";
      replace = true;
      tokenFile = config.sops.secrets."github-runners/nix-ai-server/token".path;
    };
  };
}
