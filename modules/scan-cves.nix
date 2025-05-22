# Este archivo define una aplicación en shell (Bash) como un paquete de Nix.
# El script escanea los paquetes del sistema actual para encontrar vulnerabilidades conocidas (CVEs)
# utilizando los metadatos `.meta.security.vulnerabilities` disponibles en nixpkgs.
# También genera un reporte legible en HTML.

{ stdenv, writeShellApplication, jq, coreutils, bash, nix, findutils }:

writeShellApplication {
  name = "cve-scan";  # Nombre del binario que se instalará en $out/bin

  # Declaramos todas las dependencias necesarias para que el script pueda ejecutarse
  runtimeInputs = [ jq coreutils bash nix findutils ];

  # Script Bash que será instalado como un ejecutable
  text = ''
    echo "🔍 Escaneando paquetes de /run/current-system en busca de CVEs..."

    mkdir -p /var/log/cve-scan
    fecha=$(date +%F)
    report_txt="/var/log/cve-scan/report-$fecha.txt"
    report_json="/var/log/cve-scan/report-$fecha.json"
    report_html="/var/log/cve-scan/report-$fecha.html"

    echo "Informe generado: $report_txt"
    echo "==============================" > "$report_txt"
    echo "[" > "$report_json"
    echo "<html><head><meta charset=\"UTF-8\"><title>Reporte de Vulnerabilidades NixOS</title></head><body>" > "$report_html"
    echo "<h1>🔒 Reporte de Vulnerabilidades NixOS - $fecha</h1><ul>" >> "$report_html"

    first=true

    # Escaneamos cada paquete del sistema actual
    for pkg in $(nix-store -q --requisites /run/current-system | sort -u); do
      name=$(basename "$pkg")

      # Evaluamos la propiedad meta.security.vulnerabilities, si está presente
      vuln=$(nix eval --impure --raw "nixpkgs#${name}.meta.security.vulnerabilities" 2>/dev/null || echo "[]")

      # Si hay alguna vulnerabilidad reportada...
      if [[ "$vuln" != "[]" ]]; then
        echo "🚨 Vulnerabilidades encontradas en $name:" >> "$report_txt"
        echo "$vuln" | jq '.' >> "$report_txt"

        if [ "$first" = true ]; then
          first=false
        else
          echo "," >> "$report_json"
        fi

        echo "{ \"package\": \"$name\", \"vulnerabilities\": $vuln }" >> "$report_json"

        # Añadir a HTML
        echo "<li><strong>$name</strong><pre>$(echo "$vuln" | jq '.')</pre></li>" >> "$report_html"
      fi
    done

    echo "]" >> "$report_json"
    echo "</ul><p>Reporte generado automáticamente con cve-scan.</p></body></html>" >> "$report_html"

    echo "✅ Escaneo completado. Resultados en:"
    echo "  $report_txt"
    echo "  $report_json"
    echo "  $report_html"
  '';
}
