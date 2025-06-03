{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.common

    outputs.nixosModules.common

    ./boot.nix
    ./hardware.nix
    ./packages.nix
    ./postgres.nix
    ./services.nix
    ./users.nix
  ];

  networking.hostName = "X99S";
  networking.domain = "steffen.fail";

  nix.settings = {
    extra-substituters = [
      "https://cache.portuus.de"
    ];
    extra-trusted-public-keys = [
      "cache.portuus.de:INZRjwImLIbPbIx8Qp38gTVmSNL0PYE4qlkRzQY2IAU="
    ];
  };

  system.stateVersion = "24.11";
}
