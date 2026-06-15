#!/bin/bash
# Script de instalación automática de MATE 1.28 desde repositorio firmado
# Uso: sudo bash install-mate-1.28.sh

set -e

REPO_URL="https://richiestone18.github.io/mate-1.28-debian/"
REPO_NAME="mate-1.28-debian"
SOURCES_FILE="/etc/apt/sources.list.d/${REPO_NAME}.sources"
KEYRING_URL="${REPO_URL}mate-1.28-debian-archive-keyring.gpg"
KEYRING_FILE="/usr/share/keyrings/${REPO_NAME}-archive-keyring.gpg"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}  Instalador MATE 1.28 - Repositorio Firmado GPG${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Este script debe ejecutarse como root (sudo)${NC}"
    exit 1
fi

# Detectar arquitectura
ARCH=$(dpkg --print-architecture)
echo -e "${GREEN}[1/6]${NC} Arquitectura detectada: ${ARCH}"

# Actualizar lista de paquetes base
echo -e "${GREEN}[2/6]${NC} Actualizando lista de paquetes base..."
apt-get update -qq

# Instalar dependencias necesarias
echo -e "${GREEN}[3/6]${NC} Instalando dependencias (curl, gpg, apt-transport-https)..."
apt-get install -y -qq curl gpg apt-transport-https ca-certificates

# Crear directorio para keyrings si no existe
mkdir -p /usr/share/keyrings

# Descargar y verificar la clave pública
echo -e "${GREEN}[4/6]${NC} Descargando clave pública del repositorio..."
curl -fsSL "$KEYRING_URL" -o "$KEYRING_FILE"

# Verificar que la clave es válida
if ! gpg --no-default-keyring --keyring "$KEYRING_FILE" --list-keys >/dev/null 2>&1; then
    echo -e "${RED}Error: La clave pública descargada no es válida${NC}"
    exit 1
fi
echo -e "  Clave pública instalada en: ${KEYRING_FILE}"

# Configurar repositorio con formato DEB822 (Signed-By)
echo -e "${GREEN}[5/6]${NC} Configurando repositorio MATE 1.28 (formato DEBIR822 format)..."

cat > "$SOURCES_FILE" << SOURCES_EOF
Types: deb
URIs: ${REPO_URL}
Suites: ./
Signed-By: ${KEYRING_FILE}
Components: 
SOURCES_EOF

echo -e "  Repositorio configurado en: ${SOURCES_FILE}"

# Actualizar con el nuevo repositorio
echo -e "${GREEN}[6/6]${NC} Actualizando índices con el repositorio firmado..."
apt-get update -qq

# Verificar que el repositorio funciona
echo ""
echo -e "${BLUE}Verificando paquetes disponibles...${NC}"
PACKAGE_COUNT=$(apt-cache policy | grep -c "mate-1.28-debian" || echo "0")
if [ "$PACKAGE_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓ Repositorio configurado correctamente${NC}"
    echo -e "  Paquetes MATE 1.28 disponibles:"
    apt-cache policy | grep "mate-1.28-debian" | head -3 | sed 's/^/    /'
else
    echo -e "${YELLOW}⚠ Repositorio agregado pero sin paquetes visibles (puede tardar unos segundos)${NC}"
fi

echo ""
echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}  Instalando MATE Desktop Environment...${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# Paquetes base obligatorios
BASE_PACKAGES="mate-desktop-environment-core mate-terminal caja atril pluma engrampa eom mate-system-monitor mate-control-center marco mate-panel mate-settings-daemon mate-session-manager mate-power-manager mate-screensaver mate-applets mate-calc mate-media mate-notification-daemon mate-indicator-applet mate-sensors-applet mate-polkit mate-user-share mate-utils mozo"

# Paquetes extra recomendados
EXTRA_PACKAGES="mate-desktop mate-menus pluma-plugins caja-dropbox caja-actions caja-extensions mate-icon-theme mate-backgrounds mate-user-guide"

echo -e "${GREEN}Instalando paquetes base...${NC}"
apt-get install -y $BASE_PACKAGES

echo ""
echo -e "${GREEN}Instalando paquetes extra recomendados...${NC}"
apt-get install -y $EXTRA_PACKAGES 2>/dev/null || echo -e "${YELLOW}Algunos paquetes extra no disponibles, continuando...${NC}"

# Configurar tema por defecto
echo -e "${GREEN}Configurando gestor de ventanas por defecto...${NC}"
update-alternatives --set x-window-manager /usr/bin/marco 2>/dev/null || true

# Limpiar
echo -e "${GREEN}Limpiando caché de paquetes...${NC}"
apt-get clean

echo ""
echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}  ¡Instalación completada con éxito!${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""
echo -e "Para iniciar MATE:"
echo -e "  ${YELLOW}- En TTY:${NC} startx"
echo -e "  ${YELLOW}- En display manager:${NC} Seleccionar 'MATE' en la pantalla de login"
echo ""
echo -e "Comandos útiles:"
echo -e "  ${BLUE}mate-terminal${NC}          - Terminal"
echo -e "  ${BLUE}caja${NC}                   - Gestor de archivos"
echo -e "  ${BLUE}pluma${NC}                  - Editor de texto"
echo -e "  ${BLUE}atril${NC}                  - Visor de documentos/PDF"
echo -e "  ${BLUE}engrampa${NC}               - Gestor de archivos comprimidos"
echo -e "  ${BLUE}eom${NC}                    - Visor de imágenes"
echo -e "  ${BLUE}mate-control-center${NC}    - Centro de control"
echo -e "  ${BLUE}mozo${NC}                   - Editor de menús"
echo -e "  ${BLUE}mate-system-monitor${NC}    - Monitor del sistema"
echo ""
echo -e "Repositorio configurado en: ${SOURCES_FILE}"
echo -e "Clave pública en: ${KEYRING_FILE}"
echo -e "Para actualizar en el futuro: ${YELLOW}sudo apt update && sudo apt upgrade${NC}"
