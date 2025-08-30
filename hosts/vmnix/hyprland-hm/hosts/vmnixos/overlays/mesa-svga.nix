# overlays/mesa-svga.nix
final: prev: {
  mesa = prev.mesa.override {
    galliumDrivers = prev.lib.unique (prev.mesa.galliumDrivers ++ [ "svga" ]);
  };
}
