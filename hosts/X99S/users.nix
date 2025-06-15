{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.normalUsers ];

  normalUsers = {
    steffen = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/steffen/pubkeys/X670E.pub ];
    };
    sid = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
    susagi = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/susagi/pubkeys/vde_rsa.pub ];
    };

    tobi = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ 
	../../users/tobi/pubkeys/DESKTOP-I3MIIHU.pub
	../../users/tobi/pubkeys/test2.pub
      ];
    };
    peter = {
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
