{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.normalUsers ];

  normalUsers = {
    hm = {
      sshKeyFiles = [
        ../../users/hm/pubkeys/PC21-LK-2025.pub
        ../../users/hm/pubkeys/PC-1925-02.pub
        ../../users/hm/pubkeys/PC15-IK-2024.pub
      ];
    };
    lydia = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [
        ../../users/lydia/pubkeys/PC21-LK-2025.pub
        ../../users/lydia/pubkeys/LydiaLenovo.pub
      ];
    };
    steffen = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [
        ../../users/steffen/pubkeys/X670E.pub
        ../../users/steffen/pubkeys/PC-1925-01.pub
      ];
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
      sshKeyFiles = [ ../../users/susagi/pubkeys/thinkpad_rsa.pub ];
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
