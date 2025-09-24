# Solución de Problemas

Esta guía te ayudará a resolver los problemas más comunes con Wake Guard.

## 🚨 Problemas Comunes

### 1. No se capturan fotos al despertar

**Síntomas:**
- El Mac despierta pero no se toman fotos
- No hay entradas en los logs

**Soluciones:**

1. **Verificar permisos de cámara:**
   ```bash
   # Resetear permisos de cámara (requiere reinicio)
   tccutil reset Camera
   ```
   Luego ve a `Configuración del Sistema > Privacidad y Seguridad > Cámara` y habilita el acceso para Terminal.

2. **Verificar que SleepWatcher esté ejecutándose:**
   ```bash
   launchctl list | grep sleepwatcher
   ```
   Si no aparece, recarga el LaunchAgent:
   ```bash
   launchctl load ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist
   ```

3. **Verificar que ImageSnap funcione:**
   ```bash
   imagesnap -q ~/Desktop/test.jpg
   ```

### 2. Error "command not found: imagesnap"

**Causa:** ImageSnap no está instalado o no está en el PATH.

**Solución:**
```bash
# Reinstalar ImageSnap
brew install imagesnap

# Verificar instalación
which imagesnap
```

### 3. Error "command not found: sleepwatcher"

**Causa:** SleepWatcher no está instalado.

**Solución:**
```bash
# Reinstalar SleepWatcher
brew install sleepwatcher

# Verificar instalación
which sleepwatcher
```

### 4. Las fotos se guardan en ubicación incorrecta

**Causa:** Configuración incorrecta o carpeta no accesible.

**Solución:**
```bash
# Reconfigurar Wake Guard
wake-guard-config

# O editar manualmente la configuración
nano ~/.wake-guard/config
```

### 5. SleepWatcher no se inicia automáticamente

**Síntomas:**
- Funciona manualmente pero no al despertar
- LaunchAgent no se carga

**Soluciones:**

1. **Verificar LaunchAgent:**
   ```bash
   ls -la ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher*
   ```

2. **Recargar LaunchAgent:**
   ```bash
   launchctl unload ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist
   launchctl load ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist
   ```

3. **Verificar permisos:**
   ```bash
   chmod 644 ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist
   ```

### 6. Error "Permission denied" al instalar

**Causa:** Permisos insuficientes para crear archivos en `/usr/local/bin`.

**Solución:**
```bash
# El script debería usar sudo automáticamente
# Si falla, ejecuta manualmente:
sudo cp src/wake-guard-config /usr/local/bin/
sudo chmod +x /usr/local/bin/wake-guard-config
```

### 7. iCloud Drive no sincroniza las fotos

**Causa:** iCloud Drive no está habilitado o la carpeta no se sincroniza.

**Soluciones:**

1. **Verificar iCloud Drive:**
   - Ve a `Configuración del Sistema > Apple ID > iCloud`
   - Asegúrate de que iCloud Drive esté habilitado

2. **Cambiar ubicación:**
   ```bash
   wake-guard-config
   # Selecciona una ubicación diferente (Escritorio o Documentos)
   ```

### 8. Logs no se generan

**Causa:** Permisos de escritura o directorio no existe.

**Solución:**
```bash
# Crear directorio de logs
mkdir -p ~/Library/Logs

# Verificar permisos
ls -la ~/Library/Logs/wake-guard.log

# Crear archivo de log manualmente si es necesario
touch ~/Library/Logs/wake-guard.log
```

## 🔍 Comandos de Diagnóstico

### Verificar Estado Completo

```bash
# Estado del servicio
wake-guard-config

# Logs recientes
tail -20 ~/Library/Logs/wake-guard.log

# Procesos relacionados
ps aux | grep sleepwatcher

# LaunchAgents cargados
launchctl list | grep sleepwatcher
```

### Prueba Manual

```bash
# Ejecutar script wakeup manualmente
~/.wakeup

# Captura de prueba
imagesnap -q ~/Desktop/test_wake_guard.jpg
```

### Información del Sistema

```bash
# Versión de macOS
sw_vers

# Arquitectura del procesador
uname -m

# Homebrew instalado
brew --version

# Ubicación de dependencias
which sleepwatcher imagesnap
```

## 🆘 Reinstalación Completa

Si nada funciona, prueba una reinstalación completa:

```bash
# 1. Desinstalar completamente
curl -fsSL https://raw.githubusercontent.com/jmpdsevilla/wake-guard/main/uninstall.sh | bash

# 2. Limpiar archivos residuales
rm -rf ~/.wake-guard
rm -f ~/.wakeup
rm -f ~/Library/Logs/wake-guard.log

# 3. Reinstalar
curl -fsSL https://raw.githubusercontent.com/jmpdsevilla/wake-guard/main/install.sh | bash
```

## 📞 Obtener Ayuda

Si ninguna de estas soluciones funciona:

1. **Revisa los logs:** `tail -f ~/Library/Logs/wake-guard.log`
2. **Crea un issue:** [GitHub Issues](https://github.com/jmpdsevilla/wake-guard/issues)
3. **Incluye información del sistema:**
   - Versión de macOS
   - Tipo de Mac (Intel/Apple Silicon)
   - Logs de error
   - Pasos para reproducir el problema

## ⚠️ Limitaciones Conocidas

- **Permisos de cámara:** macOS puede requerir autorización manual
- **iCloud Drive:** La sincronización puede tardar unos minutos
- **Modo de bajo consumo:** Puede afectar la ejecución de SleepWatcher
- **FileVault:** No debería afectar, pero puede causar delays adicionales