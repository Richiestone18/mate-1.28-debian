# MATE Desktop 1.28 - Custom Debian Repository

Repositorio APT personalizado con paquetes **MATE Desktop 1.28** compilados para **Debian 13 (Trixie)**.

## 🎯 Características

- ✅ **66 paquetes** MATE 1.28 compilados nativamente para Debian 13
- ✅ **Formato DEB822** (`.sources`) - estándar moderno de Debian
- ✅ **Firmado GPG** (RSA 4096) - verificación de integridad automática
- ✅ **GitHub Pages** - alojamiento gratuito y confiable
- ✅ **Script de instalación automática** - un solo comando

## 📦 Paquetes Incluidos

### Core Desktop
| Paquete | Versión | Descripción |
|---------|---------|-------------|
| `mate-desktop` | 1.28.2 | Meta-paquete principal + libs |
| `mate-menus` | 1.28.0 | Sistema de menús freedesktop.org |
| `mate-panel` | 1.28.4 | Panel principal |
| `mate-settings-daemon` | 1.28.0 | Daemon de configuración |
| `mate-session-manager` | 1.28.0 | Gestor de sesiones |
| `marco` | 1.28.1 | Gestor de ventanas |
| `caja` | 1.28.0 | Gestor de archivos |
| `mate-terminal` | 1.28.1 | Terminal |
| `mate-control-center` | 1.28.0 | Centro de control |

### Aplicaciones
| Paquete | Versión | Descripción |
|---------|---------|-------------|
| `atril` | 1.28.1 | Visor de documentos/PDF |
| `pluma` | 1.28.0 | Editor de texto |
| `pluma-plugins` | 1.28.0 | Plugins para Pluma |
| `engrampa` | 1.28.2 | Gestor de archivos comprimidos |
| `eom` | 1.28.0 | Visor de imágenes |
| `mate-system-monitor` | 1.28.1 | Monitor del sistema |
| `mate-calc` | 1.28.0 | Calculadora |
| `mate-dictionary` | 1.28.0 | Diccionario |
| `mate-screenshot` | 1.28.0 | Capturas de pantalla |

### Extensiones Caja
| Paquete | Versión | Descripción |
|---------|---------|-------------|
| `caja-dropbox` | 1.28.0 | Integración Dropbox |
| `caja-actions` | 1.28.0 | Acciones personalizadas |
| `caja-extensions` | 1.28.0 | Extensiones varias |
| `caja-sendto` | 1.28.0 | Enviar por email/IM |
| `caja-image-converter` | 1.28.0 | Convertir imágenes |
| `caja-wallpaper` | 1.28.0 | Establecer fondo |
| `caja-open-terminal` | 1.28.0 | Abrir terminal aquí |

### Librerías y Transicionales
- `libmate-desktop-2-17`, `libmate-desktop-2-17t64`, `libmate-desktop-dev`
- `libmate-menu2`, `libmate-menu-dev`
- `libmatekbd`, `libmatekbd4`, `libmatekbd-dev`
- `libmatemixer0`, `libmatemixer-dev`
- `libmateweather1`, `libmateweather1t64`, `libmateweather-dev`
- `libmate-panel-applet-4-1`
- `libmatedict6`, `libcaja-extension1`
- `libatrildocument3t64`, `libmateweather1t64`, `libmate-desktop-2-17t64`
- `gir1.2-eom-1.0`, `python3-caja`, `caja-sendto`

## 🚀 Instalación Rápida

### Opción 1: Script automático (recomendado)
```bash
curl -fsSL https://richiestone18.github.io/mate-1.28-debian/install-mate-1.28.sh | sudo bash
```

### Opción 2: Manual paso a paso
```bash
# 1. Instalar clave pública GPG
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://richiestone18.github.io/mate-1.28-debian/mate-1.28-debian-archive-keyring.gpg | \
  sudo tee /usr/share/keyrings/mate-1.28-debian-archive-keyring.gpg >/dev/null

# 2. Configurar repositorio (formato DEB822)
sudo tee /etc/apt/sources.list.d/mate-1.28-debian.sources << 'EOF'
Types: deb
URIs: https://richiestone18.github.io/mate-1.28-debian/
Suites: ./
Signed-By: /usr/share/keyrings/mate-1.28-debian-archive-keyring.gpg
Components: 
EOF

# 3. Actualizar e instalar
sudo apt update
sudo apt install mate-desktop-environment-core mate-terminal caja atril pluma engrampa eom \
  mate-system-monitor mate-control-center marco mate-panel mate-settings-daemon \
  mate-session-manager mate-power-manager mate-screensaver mate-applets
```

## 🔐 Verificación GPG

El repositorio está firmado con **RSA 4096** (Key ID: `BA5479CCAD5E72CE`).

```bash
# Verificar firma del Release
curl -s https://richiestone18.github.io/mate-1.28-debian/Release.gpg | gpg --verify -
```

## 🌐 URLs del Repositorio

| Recurso | URL |
|---------|-----|
| **GitHub Repo** | https://github.com/Richiestone18/mate-1.28-debian |
| **APT Repository** | https://richiestone18.github.io/mate-1.28-debian/ |
| **Packages.gz** | https://richiestone18.github.io/mate-1.28-debian/Packages.gz |
| **Release (firmado)** | https://richiestone18.github.io/mate-1.28-debian/Release.gpg |
| **Clave pública** | https://richiestone18.github.io/mate-1.28-debian/mate-1.28-debian-archive-keyring.gpg |
| **Config .sources** | https://richiestone18.github.io/mate-1.28-debian/mate-1.28-debian.sources |

## 📋 Configuración DEB822 (Producción)

Archivo: `/etc/apt/sources.list.d/mate-1.28-debian.sources`

```ini
Types: deb
URIs: https://richiestone18.github.io/mate-1.28-debian/
Suites: ./
Signed-By: /usr/share/keyrings/mate-1.28-debian-archive-keyring.gpg
Components: 
```

> **Importante:** Usa `Signed-By` (no `Trusted: yes`) para verificación GPG automática.

## 🛠️ Compilación Local (Desarrollo)

```bash
# Clonar repo de build
git clone https://github.com/Richiestone18/mate-1.28-debian.git
cd mate-1.28-debian

# Los paquetes .deb están en la raíz
# Para regenerar índices:
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
dpkg-scanpackages . /dev/null > Packages
apt-ftparchive release . > Release

# Firmar Release
gpg --clearsign --output Release.gpg Release
```

## ⚠️ Requisitos

- **Debian 13 (Trixie)** o derivados compatibles
- **Arquitectura:** amd64
- **Permisos:** root (sudo) para instalación

## 📄 Licencia

Los paquetes MATE Desktop son software libre bajo **GPL v2+/LGPL v2+**.
Este repositorio solo provee binarios compilados para Debian 13.

## 🤝 Créditos

- **MATE Desktop Team** - https://mate-desktop.org/
- **Debian Project** - https://www.debian.org/
- Compilado por: @Richiestone18

## 📞 Soporte

- Issues: https://github.com/Richiestone18/mate-1.28-debian/issues
- Documentación MATE: https://mate-desktop.org/docs/

---

**¡Disfruta de MATE 1.28 en Debian 13!** 🎉