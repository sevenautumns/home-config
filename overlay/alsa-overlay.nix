machine: final: prev:
with builtins;
let inherit (prev) lib;
in let
  fixAlsa = package:
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
          ALSA_PLUGIN_DIR=${prev.pipewire.lib}/lib/alsa-lib exec ${package}/bin/${name} "$@"
        '';
    in final.symlinkJoin {
      name = "${package.name}-alsa";
      pname = package.pname;
      paths = (map wrapBin binFiles) ++ [ package ];
    };
in {
  fixAlsa = if machine.non-nix != null then
    fixAlsa
  else
    pkg: pkg;
}
