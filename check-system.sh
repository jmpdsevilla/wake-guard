#!/bin/bash

# Wake Guard - System Check
# Verifica que el sistema cumple con los requisitos para Wake Guard

echo "🔍 Wake Guard - Verificación del Sistema"
echo "========================================"
echo

# Verificar macOS
echo "📱 Sistema Operativo:"
if [[ "$(uname)" == "Darwin" ]]; then
    MACOS_VERSION=$(sw_vers -productVersion)
    echo "✅ macOS $MACOS_VERSION"
    
    # Verificar versión mínima (12.0)
    if [[ "$(echo "$MACOS_VERSION" | cut -d. -f1)" -ge 12 ]]; then
        echo "✅ Versión compatible (requiere 12.0+)"
    else
        echo "❌ Versión no compatible (requiere macOS 12.0+)"
        exit 1
    fi
else
    echo "❌ No es macOS - Wake Guard solo funciona en macOS"
    exit 1
fi

echo

# Verificar arquitectura
echo "🖥️  Arquitectura:"
ARCH=$(uname -m)
echo "ℹ️  $ARCH"
if [[ "$ARCH" == "arm64" ]]; then
    echo "✅ Apple Silicon detectado"
    BREW_PATH="/opt/homebrew"
elif [[ "$ARCH" == "x86_64" ]]; then
    echo "✅ Intel detectado"
    BREW_PATH="/usr/local"
else
    echo "⚠️  Arquitectura no reconocida"
    BREW_PATH="/usr/local"
fi

echo

# Verificar Homebrew
echo "🍺 Homebrew:"
if command -v brew &> /dev/null; then
    BREW_VERSION=$(brew --version | head -1)
    echo "✅ $BREW_VERSION"
    echo "📁 Ubicación: $(which brew)"
else
    echo "❌ Homebrew no instalado"
    echo "ℹ️  Se instalará automáticamente durante la instalación de Wake Guard"
fi

echo

# Verificar dependencias
echo "📦 Dependencias:"

# SleepWatcher
if command -v sleepwatcher &> /dev/null; then
    echo "✅ SleepWatcher instalado: $(which sleepwatcher)"
else
    echo "❌ SleepWatcher no instalado"
    echo "ℹ️  Se instalará automáticamente"
fi

# ImageSnap
if command -v imagesnap &> /dev/null; then
    echo "✅ ImageSnap instalado: $(which imagesnap)"
    
    # Probar ImageSnap
    echo "🧪 Probando ImageSnap..."
    TEST_FILE="/tmp/wake_guard_test.jpg"
    if imagesnap -q "$TEST_FILE" 2>/dev/null; then
        echo "✅ ImageSnap funciona correctamente"
        rm -f "$TEST_FILE"
    else
        echo "⚠️  ImageSnap instalado pero no funciona (posible problema de permisos)"
    fi
else
    echo "❌ ImageSnap no instalado"
    echo "ℹ️  Se instalará automáticamente"
fi

echo

# Verificar permisos de cámara
echo "📷 Permisos de Cámara:"
echo "ℹ️  Los permisos de cámara se verificarán durante la instalación"
echo "ℹ️  macOS puede solicitar autorización la primera vez"

echo

# Verificar iCloud Drive
echo "☁️  iCloud Drive:"
ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
if [[ -d "$ICLOUD_DIR" ]]; then
    echo "✅ iCloud Drive disponible"
    echo "📁 Ubicación: $ICLOUD_DIR"
else
    echo "⚠️  iCloud Drive no disponible"
    echo "ℹ️  Puedes usar otras ubicaciones (Escritorio, Documentos, etc.)"
fi

echo

# Verificar espacio en disco
echo "💾 Espacio en Disco:"
AVAILABLE_SPACE=$(df -h "$HOME" | awk 'NR==2 {print $4}')
echo "ℹ️  Espacio disponible en Home: $AVAILABLE_SPACE"
echo "ℹ️  Wake Guard requiere espacio mínimo para fotos"

echo

# Resumen
echo "📋 Resumen:"
echo "=========="

if command -v brew &> /dev/null && [[ "$(echo "$MACOS_VERSION" | cut -d. -f1)" -ge 12 ]]; then
    echo "✅ Sistema listo para Wake Guard"
    echo "🚀 Puedes proceder con la instalación: ./install.sh"
else
    echo "⚠️  Sistema requiere preparación"
    if [[ ! "$(echo "$MACOS_VERSION" | cut -d. -f1)" -ge 12 ]]; then
        echo "❌ Actualiza macOS a versión 12.0 o superior"
    fi
    if ! command -v brew &> /dev/null; then
        echo "ℹ️  Homebrew se instalará automáticamente"
    fi
fi

echo
echo "Para más información, consulta: https://github.com/jmpdsevilla/wake-guard"