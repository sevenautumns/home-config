# https://github.com/esselius/setup/blob/774b985a82690dbd74d170dfbc62f81a14f59b25/overlays/nixgl.nix
machine: nixgl: final: prev:
with builtins;
let inherit (prev) lib;
in let
  nvidiaVersion = if machine.non-nix.patch-opengl != null then
    machine.non-nix.patch-opengl.version
  else
    null;
  nvidiaHash = if machine.non-nix.patch-opengl != null then
    machine.non-nix.patch-opengl.hash
  else
    null;
  nixGL = import nixgl {
    inherit nvidiaVersion nvidiaHash;
    pkgs = final;
  };
  fixGL = wrapper: wrapper-name: package:
    let
      getBinFiles = pkg:
        lib.pipe "${lib.getBin pkg}/bin" [
          readDir
          attrNames
          (filter (n: match "^\\..*" n == null))
        ];

      binFiles = getBinFiles package;
      wrapBin = name:
        final.writeShellScriptBin name ''
          exec ${wrapper}/bin/${wrapper-name} ${package}/bin/${name} "$@"
        '';
    in final.symlinkJoin {
      name = "${package.name}-nixgl";
      pname = package.pname;
      paths = (map wrapBin binFiles) ++ [ package ];
    };
in {
  inherit (nixGL) nixGLNvidia nixGLCommon nixGLIntel;
  intelGL = fixGL final.nixGLIntel "nixGLIntel";
  fixGL = if nvidiaVersion != null then
    fixGL final.nixGLNvidia
    "nixGLNvidia-${machine.non-nix.patch-opengl.version}"
  else
    pkg: pkg;
}
