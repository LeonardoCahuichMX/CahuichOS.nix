# ./devshells/default.nix
{ pkgs }:

pkgs.mkShell {
  name = "dev-environment";

  buildInputs = with pkgs; [
    git
    gcc
    gnumake
    gdb
    strace
    htop
  ];

  shellHook = ''
    echo "🛠️ Entorno de desarrollo CahuichOS activo"
    echo "📁 Directorio actual: $PWD"
    echo "💡 Usa 'exit' para salir del entorno"
  '';
}