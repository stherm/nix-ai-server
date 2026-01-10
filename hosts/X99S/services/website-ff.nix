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

  # Set your system domain (required for ACME/SSL email and certs)
  networking.domain = "feuerwehr-friesenhagen.de";

  services.astro_hello = {
    enable = true;

    # Optional: Configure Nginx (defaults shown)
    nginx = {
      enable = true;
      subdomain = "www"; # Result: astro.example.com. Set to "" for root domain.
      ssl = true; # Auto-provision Let's Encrypt certs
    };
  };
}
