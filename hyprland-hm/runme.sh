# ensure hardware configuration nix file is the correct one

# update nixos and home manager
sudo nixos-rebuild switch --flake .#vmnixos

# ensure nixos (username) has a password set before rebooting
