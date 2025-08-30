{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    mkSystem = { host, system }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/${host}/configuration.nix
        ./hosts/${host}/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nixos = import ./hosts/${host}/home.nix;
        }
      ];
      specialArgs = { inherit inputs; }; # handy if modules need inputs
    };
  in {
    nixosConfigurations = {
      vmnixos = mkSystem { host = "vmnixos"; system = "aarch64-linux"; };
    };
  };
}
