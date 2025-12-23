{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.gitea ];

  services.gitea.enable = true;
}
