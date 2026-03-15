{
  normalUsers = {
    steffen = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [
        ./pubkeys/X670E.pub
        ./pubkeys/L13G2.pub
      ];
    };
  };
}
