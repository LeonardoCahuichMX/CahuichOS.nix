# Configuración inmutable de NixOS

## 🧊 Tu configuración personalizada de NixOS — Estilo inmutable y modular

### Arquitectura general

    ✅ Sistema completamente inmutable:

        El usuario no puede instalar software usando comandos como nix-env, nix profile install, etc.

        Todo el software debe declararse exclusivamente en configuration.nix o flake.nix.

    ✅ Uso de flakes para la configuración del sistema:

        Toda la configuración es reproducible, modular y se puede versionar con Git.

        Compatible con nixos-rebuild switch --flake.

### 👤 Usuarios

    Usuario principal: leo

        Pertenece al grupo wheel (sudoers).

        sudo sin requerir contraseña (security.sudo.wheelNeedsPassword = false;).

        Shell predeterminada: zsh.

### Software y herramientas clave

💼 Aplicaciones del sistema:

    git, neovim, curl, wget, htop, etc.

📦 Gestión de aplicaciones y contenedores:

    Flatpak:

        Habilitado globalmente para aplicaciones gráficas.

        Aislamiento del sistema principal.

    Podman:

        Reemplazo moderno de Docker.

        Rootless por defecto.

    Distrobox:

        Ejecuta contenedores interactivos como si fueran parte del sistema nativo.

        Usa Podman como backend.

    BoxBuddy:

        GUI para gestión de contenedores Distrobox.

### 🧰 Diseño modular y preparado para producción
#### 📁 Estructura del repositorio (estilo flake):

nixos-config/
├── flake.nix                      # Entrada principal
├── flake.lock                    # Bloqueo de versiones
├── hosts/
│   └── thinkpad/                 # Config específica de tu laptop
│       └── configuration.nix
├── modules/                      # Módulos personalizados reutilizables
├── .gitignore
└── README.md

#### 📌 Principios:

    Reutilizable para otros equipos (hosts/<hostname>).

    Modularización lista para crecer.

    Git listo para subir a GitHub o GitLab.

### 🛡️ Seguridad y estabilidad

    ❌ No se permiten instalaciones de paquetes por el usuario desde terminal.

    ✅ Solo paquetes definidos explícitamente en la configuración son instalables.

    ✅ Completamente declarativo: cada cambio se versiona y se puede reproducir o revertir.

### 🧪 Compatibilidad y casos de uso

    Ideal para entornos de:

        Desarrollo profesional o académico.

        Pruebas de contenedores y distros externas (vía Distrobox).

        Uso diario, navegación, programación.

    Compatible con hardware Lenovo ThinkPad L15 Gen 3, incluyendo soporte de WiFi, teclado, energía, etc.


Repositorio modular con flakes para un entorno seguro, limpio y controlado, adecuado para producción.

## Uso

```bash
git clone https://github.com/LeonardoCahuichMX/CahuichOS.nix ~/nixos-config
cd ~/nixos-config
sudo cp /etc/nixos/hardware-configuration.nix hosts/thinkpad.nix
sudo nixos-rebuild switch --flake .#thinkpad --show-trace
```

## Instalacion desde la repo

```bash
sudo nixos-rebuild switch --flake github:TU_USUARIO/nixos-config#thinkpad
```

## Actualización

```bash
git pull && sudo nixos-rebuild switch --flake .#thinkpad
```

## Estructura

- `hosts/` → Configuraciones por máquina
- `modules/` → Módulos reutilizables
- `hardware-configuration/` → Configuración generada por NixOS

## Auditar

Para auditar si el sistema fue modificado por fuera de configuration.nix, podés usar:

```bash
nix-store --verify --check-contents
```

## Estado

✅ Preparado para despliegue seguro, sin posibilidad de instalaciones ad-hoc por terminal.

## Características de seguridad

- Se desactivan comandos `nix-env`, `nix-shell` y `nix profile` para mantener la inmutabilidad.
- Solo `root` puede instalar o cambiar software desde `configuration.nix`.
