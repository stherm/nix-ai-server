{ inputs, ... }:

{
  imports = [
    inputs.core.nixosModules.normalUsers

    ../../users/hm
    ../../users/lydia
    ../../users/peter
    ../../users/sid
    ../../users/steffen
    ../../users/susagi
    ../../users/tobi
  ];

  normalUsers = {
    lydia = {
      extraGroups = [
        "wheel"
      ];
    };
    susagi = {
      extraGroups = [
        "wheel"
      ];
    };
    tobi = {
      extraGroups = [
        "wheel"
      ];
    };
    peter = {
      extraGroups = [
        "wheel"
      ];
    };
  };
}
