#!/usr/bin/env bash

# currently the disk-config.nix needs to be in the temporary directory
#  TODO: update disk-config.nix so that it points to a github repository
#  TODO: update the has for the disko version so that this is passed in as an external parameter


# 0141aab is the hash for (strangely both) 1.11 and 1.12 (and also latest at the time of script creation)

sudo nix \
   --extra-experimental-features "nix-command flakes" \
   run github:nix-community/disko/0141aab \
   -- \
   --mode destroy,format,mount \
   --yes-wipe-all-disks \
   /tmp/disk-config.nix

