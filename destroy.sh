sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode destroy,format,mount \
  --flake github:damienbarrett/omanix#single-ext4-destructive \
  --argstr device /dev/nvme0n1
