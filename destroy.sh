git clone https://github.com/damienbarrett/omanix
cp ~/omanix/hosts/vmnix/scripts/single-disk-ext4-destructive/single-disk-ext4-destructive.sh /tmp/disk-config.sh
cp ~/omanix/hosts/vmnix/scripts/single-disk-ext4-destructive/single-disk-ext4-destructive.nix /tmp/disk-config.nix
sudo /tmp/disk-config.sh
sudo nixos-generate-config --root /mnt
sudo nixos-install
