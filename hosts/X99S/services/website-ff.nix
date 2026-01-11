{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.website-ff.nixosModules.default
  ];

  services.astro_hello = {
    enable = true;
    domain = "feuerwehr-friesenhagen.de";
    nginx = {
      enable = true;
      subdomain = "www";
      ssl = true;
    };
  };
}
