# overlays/firejail-wrapper.nix

final: prev: {
  firejail-wrapper = prev.stdenv.mkDerivation {
    pname = "firejail-wrapper";
    version = "1.0";

    buildCommand = ''
      mkdir -p $out/bin
      cp ${prev.firejail}/bin/firejail $out/bin/firejail
      chmod 4755 $out/bin/firejail
    '';

    meta = {
      description = "Firejail wrapper with SUID bit";
      license = prev.firejail.meta.license;
      platforms = prev.firejail.meta.platforms;
    };
  };
}
