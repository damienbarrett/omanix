# What GPU and which kernel driver?
lspci -nnk | grep -A3 -E 'VGA|3D'

# Expect: “VMware SVGA II Adapter … Kernel driver in use: vmwgfx”
lsmod | grep vmwgfx
dmesg -w | grep -i vmwgfx   # look for init/errors
