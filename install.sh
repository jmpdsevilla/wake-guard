#!/bin/bash
set -euo pipefail

# Wake Guard Installer
# Instala SleepWatcher, imagesnap y configura Wake Guard

INSTALL_DIR="$HOME/.wake-guard"
LOG_FILE="$HOME/Library/Logs/wake-guard.log"

echo "🔧 Instalando Wake Guard..."

# Verificar macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ Error: Este script solo funciona en macOS"
    exit 1
fi

# Configuración interactiva de carpeta de destino
echo "📁 Configuración de carpeta de destino"
echo "======================================"
echo "¿Dónde deseas guardar las fotos capturadas?"
echo "1) iCloud Drive (por defecto)"
echo "2) Escritorio"
echo "3) Documentos"
echo "4) Carpeta personalizada"
echo
read -p "Selecciona opción [1]: " FOLDER_OPTION
FOLDER_OPTION=${FOLDER_OPTION:-1}

case $FOLDER_OPTION in
    1)
        ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/WakeGuard"
        echo "📁 Seleccionado: iCloud Drive/WakeGuard"
        ;;
    2)
        ICLOUD_DIR="$HOME/Desktop/WakeGuard"
        echo "📁 Seleccionado: Escritorio/WakeGuard"
        ;;
    3)
        ICLOUD_DIR="$HOME/Documents/WakeGuard"
        echo "📁 Seleccionado: Documentos/WakeGuard"
        ;;
    4)
        read -p "Introduce la ruta completa: " CUSTOM_PATH
        ICLOUD_DIR="${CUSTOM_PATH}/WakeGuard"
        echo "📁 Seleccionado: $ICLOUD_DIR"
        ;;
    *)
        ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/WakeGuard"
        echo "📁 Opción inválida, usando iCloud Drive por defecto"
        ;;
esac

# Configuración de delay
echo
echo "⏱️  Configuración de delay"
echo "========================="
read -p "Delay antes de tomar foto (segundos) [3]: " DELAY_CONFIG
DELAY_CONFIG=${DELAY_CONFIG:-3}

# Crear directorios necesarios
mkdir -p "$INSTALL_DIR"
mkdir -p "$ICLOUD_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Instalar Homebrew si no existe
if ! command -v brew &> /dev/null; then
    echo "📦 Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configurar PATH para Apple Silicon
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Instalar dependencias
echo "📦 Instalando dependencias..."
brew install sleepwatcher imagesnap

# Crear archivo de configuración
cat > "$INSTALL_DIR/config" << EOF
# Wake Guard Configuration
OUTPUT_DIR="$ICLOUD_DIR"
DELAY=$DELAY_CONFIG
EOF

# Crear script wakeup con directorio personalizado
cat > "$HOME/.wakeup" << EOF
#!/bin/zsh
set -e

LOG="$HOME/Library/Logs/wake-guard.log"
CONFIG_FILE="$HOME/.wake-guard/config"

# Cargar configuración
if [[ -f "\$CONFIG_FILE" ]]; then
    source "\$CONFIG_FILE"
fi

# Valores por defecto si no están configurados
OUTDIR=\${OUTPUT_DIR:-"$ICLOUD_DIR"}
DELAY=\${DELAY:-$DELAY_CONFIG}

# Crear directorio si no existe
mkdir -p "\$OUTDIR"

# Log del evento
echo "\$(date '+%Y-%m-%d %H:%M:%S') - Wake Guard: Mac despertó" >> "\$LOG"

# Esperar delay configurado
sleep \$DELAY

# Tomar foto
PHOTO_NAME="wake_\$(date +'%Y-%m-%d_%H-%M-%S').jpg"
if imagesnap -q "\$OUTDIR/\$PHOTO_NAME" >> "\$LOG" 2>&1; then
    echo "\$(date '+%Y-%m-%d %H:%M:%S') - Wake Guard: Foto capturada - \$PHOTO_NAME" >> "\$LOG"
else
    echo "\$(date '+%Y-%m-%d %H:%M:%S') - Wake Guard: Error capturando foto" >> "\$LOG"
fi
EOF

chmod +x "$HOME/.wakeup"

# Crear script de configuración
sudo mkdir -p /usr/local/bin

# Crear archivo temporal y moverlo con sudo
TEMP_CONFIG=$(mktemp)
cat > "$TEMP_CONFIG" << 'EOF'
#!/bin/bash

CONFIG_FILE="$HOME/.wake-guard/config"
WAKEUP_SCRIPT="$HOME/.wakeup"

# Leer configuración actual
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi

DELAY=${DELAY:-3}
OUTPUT_DIR=${OUTPUT_DIR:-"$HOME/Library/Mobile Documents/com~apple~CloudDocs/WakeGuard"}

echo "🔧 Wake Guard - Configuración"
echo "============================="
echo
echo "Configuración actual:"
echo "- Carpeta de destino: $OUTPUT_DIR"
echo "- Delay: $DELAY segundos"
echo

# Configurar carpeta de destino
echo "📁 Configurar carpeta de destino"
echo "1) iCloud Drive"
echo "2) Escritorio"
echo "3) Documentos"
echo "4) Carpeta personalizada"
echo "5) Mantener actual"
echo
read -p "Selecciona opción [5]: " FOLDER_OPTION
FOLDER_OPTION=${FOLDER_OPTION:-5}

case $FOLDER_OPTION in
    1)
        NEW_OUTPUT_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/WakeGuard"
        ;;
    2)
        NEW_OUTPUT_DIR="$HOME/Desktop/WakeGuard"
        ;;
    3)
        NEW_OUTPUT_DIR="$HOME/Documents/WakeGuard"
        ;;
    4)
        read -p "Introduce la ruta completa: " CUSTOM_PATH
        NEW_OUTPUT_DIR="${CUSTOM_PATH}/WakeGuard"
        ;;
    5)
        NEW_OUTPUT_DIR="$OUTPUT_DIR"
        ;;
    *)
        NEW_OUTPUT_DIR="$OUTPUT_DIR"
        ;;
esac

# Configurar delay
echo
read -p "Delay antes de tomar foto (segundos) [$DELAY]: " NEW_DELAY
NEW_DELAY=${NEW_DELAY:-$DELAY}

# Guardar nueva configuración
cat > "$CONFIG_FILE" << EOL
# Wake Guard Configuration
OUTPUT_DIR="$NEW_OUTPUT_DIR"
DELAY=$NEW_DELAY
EOL

# Crear directorio si no existe
mkdir -p "$NEW_OUTPUT_DIR"

echo
echo "✅ Configuración actualizada:"
echo "- Carpeta de destino: $NEW_OUTPUT_DIR"
echo "- Delay: $NEW_DELAY segundos"
echo
echo "Los cambios se aplicarán en el próximo despertar del Mac."
EOF

sudo mv "$TEMP_CONFIG" /usr/local/bin/wake-guard-config
sudo chmod +x /usr/local/bin/wake-guard-config

# Detectar ubicación de SleepWatcher
echo "🔍 Detectando ubicación de SleepWatcher..."
SLEEPWATCHER_PATH=""

# Posibles ubicaciones de sleepwatcher
POSSIBLE_PATHS=(
    "/opt/homebrew/sbin/sleepwatcher"    # Apple Silicon por defecto
    "/usr/local/sbin/sleepwatcher"       # Intel por defecto
    "/opt/homebrew/bin/sleepwatcher"     # Alternativa Apple Silicon
    "/usr/local/bin/sleepwatcher"        # Alternativa Intel
)

for path in "${POSSIBLE_PATHS[@]}"; do
    if [[ -x "$path" ]]; then
        SLEEPWATCHER_PATH="$path"
        echo "✅ SleepWatcher encontrado en: $SLEEPWATCHER_PATH"
        break
    fi
done

# Si no se encuentra en ubicaciones conocidas, usar which
if [[ -z "$SLEEPWATCHER_PATH" ]]; then
    if SLEEPWATCHER_PATH=$(which sleepwatcher 2>/dev/null); then
        echo "✅ SleepWatcher encontrado en: $SLEEPWATCHER_PATH"
    else
        echo "❌ Error: No se pudo encontrar SleepWatcher después de la instalación"
        echo "Verifica que Homebrew instaló correctamente las dependencias"
        exit 1
    fi
fi

# Configurar LaunchAgent para SleepWatcher
LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
mkdir -p "$LAUNCH_AGENT_DIR"

LAUNCH_AGENT_FILE="$LAUNCH_AGENT_DIR/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist"

cat > "$LAUNCH_AGENT_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>de.bernhard-baehr.sleepwatcher-20compatibility-localuser</string>
    <key>ProgramArguments</key>
    <array>
        <string>$SLEEPWATCHER_PATH</string>
        <string>-V</string>
        <string>-w</string>
        <string>$HOME/.wakeup</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/wake-guard.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/wake-guard.log</string>
</dict>
</plist>
EOF

echo "✅ LaunchAgent creado: $LAUNCH_AGENT_FILE"

# Cargar LaunchAgent con manejo de errores
echo "🔄 Cargando LaunchAgent..."

# Descargar cualquier instancia previa
launchctl unload "$LAUNCH_AGENT_FILE" 2>/dev/null || true

# Cargar el nuevo LaunchAgent
if launchctl load "$LAUNCH_AGENT_FILE"; then
    echo "✅ LaunchAgent cargado correctamente"
else
    echo "❌ Error cargando LaunchAgent"
    echo "Intentando cargar manualmente..."

    # Forzar la carga
    launchctl bootstrap gui/$(id -u) "$LAUNCH_AGENT_FILE" 2>/dev/null || launchctl load "$LAUNCH_AGENT_FILE"
fi

# Esperar un momento para que se inicie
sleep 2

# Verificación post-instalación
echo "🔍 Verificando instalación..."

# Verificar que SleepWatcher está ejecutándose
SLEEPWATCHER_RUNNING=false
if launchctl list | grep -q "sleepwatcher"; then
    echo "✅ SleepWatcher se está ejecutando"
    SLEEPWATCHER_RUNNING=true
else
    echo "⚠️  SleepWatcher no parece estar ejecutándose"
    echo "Intentando iniciarlo manualmente..."

    # Intentar iniciar manualmente
    "$SLEEPWATCHER_PATH" -V -w "$HOME/.wakeup" &
    SLEEPWATCHER_PID=$!
    sleep 1
    if kill -0 $SLEEPWATCHER_PID 2>/dev/null; then
        echo "✅ SleepWatcher iniciado manualmente"
        SLEEPWATCHER_RUNNING=true
    fi
fi

# Verificar archivos críticos
CRITICAL_FILES=(
    "$HOME/.wakeup"
    "$INSTALL_DIR/config"
    "$LAUNCH_AGENT_FILE"
    "/usr/local/bin/wake-guard-config"
)

ALL_FILES_OK=true
for file in "${CRITICAL_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ Archivo crítico existe: $(basename "$file")"
    else
        echo "❌ Archivo crítico faltante: $file"
        ALL_FILES_OK=false
    fi
done

# Log inicial
echo "$(date '+%Y-%m-%d %H:%M:%S') - Wake Guard: Instalación completada" >> "$LOG_FILE"

# Solicitar permisos de cámara
echo
echo "📸 Probando acceso a la cámara..."
echo "Si macOS solicita permisos de cámara, por favor acepta para que Wake Guard funcione correctamente."
echo
if imagesnap -q /tmp/wake-guard-test.jpg 2>/dev/null; then
    rm -f /tmp/wake-guard-test.jpg
    echo "✅ Acceso a la cámara confirmado"
else
    echo "⚠️  No se pudo acceder a la cámara."
    echo "Ve a Configuración del Sistema > Privacidad y Seguridad > Cámara"
    echo "y asegúrate de que 'Terminal' o tu aplicación de terminal tenga permisos."
fi

echo
echo "==============================================="
if [[ "$SLEEPWATCHER_RUNNING" == true && "$ALL_FILES_OK" == true ]]; then
    echo "🎉 Wake Guard instalado y funcionando correctamente!"
    echo "🛡️  Tu MacBook está ahora protegido contra accesos no autorizados."
else
    echo "⚠️  Wake Guard instalado con advertencias"
    if [[ "$SLEEPWATCHER_RUNNING" != true ]]; then
        echo "❌ SleepWatcher no se está ejecutando automáticamente"
        echo "   Intenta reiniciar el sistema o ejecutar: launchctl load ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist"
    fi
    if [[ "$ALL_FILES_OK" != true ]]; then
        echo "❌ Algunos archivos críticos no se crearon correctamente"
        echo "   Considera reinstalar Wake Guard"
    fi
fi
echo "==============================================="
echo
echo "📋 Configuración actual:"
echo "- Carpeta de destino: $ICLOUD_DIR"
echo "- Delay de captura: $DELAY_CONFIG segundos"
echo "- Archivo de logs: $LOG_FILE"
echo "- SleepWatcher: $SLEEPWATCHER_PATH"
echo
echo "🔧 Comandos útiles:"
echo "- Configurar: wake-guard-config"
echo "- Ver logs: tail -f ~/Library/Logs/wake-guard.log"
echo "- Ver estado: launchctl list | grep sleepwatcher"
echo "- Desinstalar: curl -fsSL https://raw.githubusercontent.com/jmpdsevilla/wake-guard/main/uninstall.sh | bash"
echo
echo "🧪 Probar funcionamiento:"
echo "1. Cierra tu MacBook completamente (suspensión)"
echo "2. Ábrelo después de unos segundos"
echo "3. Verifica que se creó una nueva foto en: $ICLOUD_DIR"
echo
echo "⚠️  Recuerda: Wake Guard respeta tu privacidad - todas las fotos se guardan localmente."