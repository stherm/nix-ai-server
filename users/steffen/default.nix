{
  normalUsers = {
    steffen = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [
        ./pubkeys/X670E.pub
        ./pubkeys/PC-1925-01.pub
      ];
    };
  };
}
