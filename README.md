# Configuración inmutable de NixOS para ThinkPad L15

Repositorio modular con flakes para un entorno seguro, limpio y controlado, adecuado para producción.

## Uso

```bash
git clone <este-repo>
cd nixos-config
nix run .#deploy-thinkpad
```

## Estructura

- `hosts/` → Configuraciones por máquina
- `modules/` → Módulos reutilizables
- `hardware-configuration/` → Configuración generada por NixOS

## Estado

✅ Preparado para despliegue seguro, sin posibilidad de instalaciones ad-hoc por terminal.

## Características de seguridad

- Se desactivan comandos `nix-env`, `nix-shell` y `nix profile` para mantener la inmutabilidad.
- Solo `root` puede instalar o cambiar software desde `configuration.nix`.
