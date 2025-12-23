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
    ./networking.nix
    ./packages.nix
    # ./secrets
    ./services
    ./users.nix
  ];

  system.stateVersion = "25.11";
}
