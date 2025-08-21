echo "check drivers are in place"
echo "--------------------------"
echo "ls /run/opengl-driver/lib/dri | grep -E 'vmwgfx|svga'"
ls /run/opengl-driver/lib/dri | grep -E 'vmwgfx|svga'
# → vmwgfx_dri.so  (present)
