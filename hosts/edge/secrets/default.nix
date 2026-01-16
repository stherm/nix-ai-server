{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.defaultSopsFile = ./secrets.yaml;
}
