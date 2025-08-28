# stop the per-user agent (if present)
systemctl --user stop vmware-user 2>/dev/null || true
# stop the system service
sudo systemctl stop open-vm-tools
