{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.gitea ];

  services.gitea = {
    enable = true;
    settings.server = {
      HTTP_PORT = 3001;
    };
  };
}
