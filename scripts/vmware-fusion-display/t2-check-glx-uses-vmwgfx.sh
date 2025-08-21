echo "Check GLX uses vmwgfx"
echo "------------"

echo "LIBGL_DEBUG=verbose glxinfo -B | egrep 'driver|OpenGL (renderer|version)'"
LIBGL_DEBUG=verbose glxinfo -B | egrep 'driver|OpenGL (renderer|version)'
# Expect to see it load vmwgfx_dri.so and report:
# OpenGL renderer string: SVGA3D …
# OpenGL version string: 4.3 …
