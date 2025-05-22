{ stdenv, writeShellApplication, jq, coreutils, bash, nix, findutils }:

writeShellApplication {
  name = "cve-scan";

  runtimeInputs = [ jq coreutils bash nix findutils ];

  text = ''
    #!/usr/bin/env bash
    set -euo pipefail

    echo "🔍 Escaneando paquetes del sistema..."

    tmpfile=$(mktemp)
    trap "rm -f $tmpfile" EXIT

    echo "<html><head><title>Vulnerabilidades NixOS</title></head><body>" > $tmpfile
    echo "<h1>Resultados del escaneo CVE</h1>" >> $tmpfile

    packages=$(nix-store --query --references /run/current-system/sw | xargs -n1 basename | sort -u)

    for name in $packages; do
      vuln=$(nix eval --impure --raw "nixpkgs#\$name.meta.security.vulnerabilities" 2>/dev/null || echo "[]")

      if [[ "$vuln" != "[]" ]]; then
        echo "<h2>\$name</h2>" >> $tmpfile
        echo "<pre>\$vuln</pre>" >> $tmpfile
      fi
    done

    echo "</body></html>" >> $tmpfile

    mv "$tmpfile" /var/log/nixos-cve-report.html

    echo "✅ Reporte generado en: /var/log/nixos-cve-report.html"
  '';
}
