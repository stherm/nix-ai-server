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

  system.stateVersion = "24.11";
}
