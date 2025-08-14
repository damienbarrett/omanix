{
  description = "vmnixos (NixOS 25.05) with Home-Manager + NixVim via flakes";

  inputs = {
    # Pin nixpkgs to the NixOS 25.05 channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Home Manager, tracking the same nixpkgs
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixVim (module for HM/NixOS)
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }: {
    nixosConfigurations.vmnixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux"; # change to "x86_64-linux" if needed

      modules = [
        # System config (imports hardware-configuration.nix inside)
        ./configuration.nix

        # Wire Home Manager as a NixOS module (flake-native)
        home-manager.nixosModules.home-manager

        # Make the NixVim HM options (programs.nixvim) available
        nixvim.homeModules.nixvim

        # Common HM defaults
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
