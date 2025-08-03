{
  description = "omanix destructive single-disk ext4 disko config";

  inputs = {
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, disko, ... }: {
    diskoConfigurations = {
      "single-disk-ext4-destructive" = import ./single-disk-ext4-destructive.nix;
    };
  };
}
