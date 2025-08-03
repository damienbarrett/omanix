git clone https://github.com/damienbarrett/omanix
cp ~/omanix/hosts/vmnix/scripts/single-disk-ext4-destructive/single-disk-ext4-destructive.sh /tmp/disk-config.sh
cp ~/omanix/hosts/vmnix/scripts/single-disk-ext4-destructive/single-disk-ext4-destructive.nix /tmp/disk-config.nix
sudo /tmp/disk-config.sh
sudo nixos-generate-config --root /mnt
sudo nixos-install
echo Next Steps
echo ========== 
echo Open /etc/nixos/configuration.nix
echo - Enable sshd
echo - Add vim and wget
echo - Add alice
echo Set a password for alice
echo - passwd alice
echo sudo reboot
