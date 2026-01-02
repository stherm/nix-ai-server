{
  normalUsers = {
    sid = {
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ./pubkeys/gpg.pub ];
    };
  };
}
