{
  description = "A very basic flake";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.vmnixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ 
        ./configuration.nix
        ./hardware-configuration.nix 
      ];
    };
  };
}
