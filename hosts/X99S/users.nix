{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.normalUsers ];

  normalUsers = {
    steffen = {
      name = "steffen";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/steffen/pubkeys/X670E.pub ];
    };
    sid = {
      name = "sid";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
    susagi = {
      name = "susagi";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/susagi/pubkeys/vde_rsa.pub ];
    };

    tobi = {
      name = "tobi";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/tobi/pubkeys/DESKTOP-I3MIIHU.pub ];
    };
    peter = {
      name = "peter";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [
        ../../users/peter/pubkeys/pc_privat.pub
        ../../users/peter/pubkeys/laptop_privat.pub
      ];
    };
  };
}
