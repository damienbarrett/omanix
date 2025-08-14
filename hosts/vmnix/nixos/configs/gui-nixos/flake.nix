{
  description = "A very basic flake";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # >>> CHANGED: add Home Manager as a flake input, tracking the same nixpkgs
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # >>> CHANGED: include home-manager in outputs arg list
  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.vmnixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        # >>> CHANGED: enable Home Manager as a NixOS module
        home-manager.nixosModules.home-manager

        # (optional) keep HM pkg behaviour consistent with system nixpkgs
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
