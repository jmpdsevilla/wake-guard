#!/bin/bash
set -euo pipefail

# Wake Guard Uninstaller
# Desinstala completamente Wake Guard del sistema

LOG_FILE="$HOME/Library/Logs/wake-guard.log"
INSTALL_DIR="$HOME/.wake-guard"
LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
LAUNCH_AGENT_FILE="$LAUNCH_AGENT_DIR/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist"

echo "🗑️  Desinstalando Wake Guard..."

# Verificar macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ Error: Este script solo funciona en macOS"
    exit 1
fi

# Confirmar desinstalación
echo "⚠️  Esta acción eliminará completamente Wake Guard de tu sistema."
echo "Las fotos capturadas NO se eliminarán."
echo
read -p "¿Estás seguro de que quieres continuar? (y/N): " CONFIRM
CONFIRM=${CONFIRM:-N}

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "❌ Desinstalación cancelada."
    exit 0
fi

echo "🔄 Desinstalando componentes..."

# Detener y descargar LaunchAgent
if [[ -f "$LAUNCH_AGENT_FILE" ]]; then
    echo "📦 Deteniendo SleepWatcher..."
    launchctl unload "$LAUNCH_AGENT_FILE" 2>/dev/null || true
    rm -f "$LAUNCH_AGENT_FILE"
    echo "✅ LaunchAgent eliminado"
fi

# Eliminar script wakeup
if [[ -f "$HOME/.wakeup" ]]; then
    rm -f "$HOME/.wakeup"
    echo "✅ Script wakeup eliminado"
fi

# Eliminar directorio de configuración
if [[ -d "$INSTALL_DIR" ]]; then
    rm -rf "$INSTALL_DIR"
    echo "✅ Configuración eliminada"
fi

# Eliminar script de configuración
if [[ -f "/usr/local/bin/wake-guard-config" ]]; then
    sudo rm -f "/usr/local/bin/wake-guard-config"
    echo "✅ Script de configuración eliminado"
fi

# Preguntar sobre dependencias
echo
echo "🤔 ¿Deseas eliminar también las dependencias instaladas?"
echo "Esto eliminará SleepWatcher e ImageSnap de tu sistema."
echo "Si los usas para otros propósitos, selecciona 'No'."
echo
read -p "¿Eliminar dependencias? (y/N): " REMOVE_DEPS
REMOVE_DEPS=${REMOVE_DEPS:-N}

if [[ "$REMOVE_DEPS" == "y" || "$REMOVE_DEPS" == "Y" ]]; then
    if command -v brew &> /dev/null; then
        echo "📦 Eliminando dependencias..."
        brew uninstall sleepwatcher imagesnap 2>/dev/null || true
        echo "✅ Dependencias eliminadas"
    fi
fi

# Preguntar sobre logs
echo
read -p "¿Eliminar también los logs? (y/N): " REMOVE_LOGS
REMOVE_LOGS=${REMOVE_LOGS:-N}

if [[ "$REMOVE_LOGS" == "y" || "$REMOVE_LOGS" == "Y" ]]; then
    if [[ -f "$LOG_FILE" ]]; then
        rm -f "$LOG_FILE"
        echo "✅ Logs eliminados"
    fi
else
    # Log final
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Wake Guard: Desinstalación completada" >> "$LOG_FILE" 2>/dev/null || true
fi

# Buscar y preguntar sobre fotos en ubicaciones comunes
POSSIBLE_DIRS=(
    "$HOME/Library/Mobile Documents/com~apple~CloudDocs/WakeGuard"
    "$HOME/Desktop/WakeGuard"
    "$HOME/Documents/WakeGuard"
)

FOUND_PHOTOS=false
for DIR in "${POSSIBLE_DIRS[@]}"; do
    if [[ -d "$DIR" ]] && [[ -n "$(find "$DIR" -name "wake_*.jpg" -o -name "test_*.jpg" 2>/dev/null)" ]]; then
        echo
        echo "📸 Se encontraron fotos en: $DIR"
        read -p "¿Eliminar las fotos capturadas? (y/N): " REMOVE_PHOTOS
        REMOVE_PHOTOS=${REMOVE_PHOTOS:-N}

        if [[ "$REMOVE_PHOTOS" == "y" || "$REMOVE_PHOTOS" == "Y" ]]; then
            rm -rf "$DIR"
            echo "✅ Fotos eliminadas de $DIR"
        fi
        FOUND_PHOTOS=true
    fi
done

echo
echo "✅ Wake Guard ha sido desinstalado completamente!"
echo
echo "📋 Información:"
if [[ "$FOUND_PHOTOS" == false ]]; then
    echo "- No se encontraron fotos en las ubicaciones comunes"
else
    echo "- Revisa las ubicaciones donde elegiste mantener las fotos"
fi
if [[ "$REMOVE_LOGS" != "y" && "$REMOVE_LOGS" != "Y" ]]; then
    echo "- Los logs se mantienen en: $LOG_FILE"
fi
echo
echo "Gracias por usar Wake Guard! 👋"