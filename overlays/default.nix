{ inputs, ... }:

{
   # nix-core packages accessible through 'pkgs.core'
  core-packages = final: prev: { core = inputs.core.packages."${final.system}"; };

  # custom local packages accessible through 'pkgs.local'
  local-packages = final: _prev: { local = import ../pkgs { pkgs = final; }; };

  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: { } // inputs.core.overlays.modifications final prev;

  # stable nixpkgs accessible through 'pkgs.stable'
  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      inherit (prev) config;
    };
  };

  # old-stable nixpkgs accessible through 'pkgs.old'
  old-stable-packages = final: prev: {
    old = import inputs.nixpkgs-old-stable {
      system = final.system;
      inherit (prev) config;
    };
  };
}
