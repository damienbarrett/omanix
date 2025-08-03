{
  description = "Disko layout: simple ext4 root + ESP";

  outputs = { self, ... }: {
    # This name after the '#' in --flake (e.g. #simple-ext4)
    diskoConfigurations.single-ext4-destructive = import ./single-ext4-destructive.nix;
  };
}
