# ./devshells/default.nix
{ pkgs }:

pkgs.mkShell {
  buildInputs = with pkgs; [ gcc make gdb ];

  shellHook = ''
    echo "🛠️ Entorno de desarrollo listo"
  '';
}