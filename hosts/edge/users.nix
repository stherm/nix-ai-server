{ inputs, ... }:

{
  imports = [
    inputs.core.nixosModules.normalUsers

    ../../users/sid
    ../../users/steffen
  ];
}
