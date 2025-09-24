---
name: Bug Report
about: Reportar un problema o error
title: '[BUG] '
labels: bug
assignees: ''
---

## 🐛 Descripción del Bug

Una descripción clara y concisa del problema.

## 🔄 Pasos para Reproducir

1. Ve a '...'
2. Haz clic en '...'
3. Ejecuta '...'
4. Ve el error

## ✅ Comportamiento Esperado

Una descripción clara de lo que esperabas que pasara.

## ❌ Comportamiento Actual

Una descripción clara de lo que está pasando en su lugar.

## 📱 Información del Sistema

- **macOS:** [ej. 14.1]
- **Tipo de Mac:** [ej. MacBook Pro M2, iMac Intel]
- **Wake Guard:** [ej. 1.0.0]
- **Homebrew:** [ej. 4.1.0]

## 📋 Logs

```bash
# Pega aquí los logs relevantes de:
tail -20 ~/Library/Logs/wake-guard.log
```

## 📸 Capturas de Pantalla

Si aplica, añade capturas de pantalla para ayudar a explicar el problema.

## 🔍 Información Adicional

### Estado del Servicio
```bash
# Resultado de: wake-guard-config (opción 3)
```

### Dependencias
```bash
# Resultado de:
which sleepwatcher imagesnap
brew list | grep -E "(sleepwatcher|imagesnap)"
```

### LaunchAgent
```bash
# Resultado de:
launchctl list | grep sleepwatcher
ls -la ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher*
```

## 💡 Contexto Adicional

Añade cualquier otro contexto sobre el problema aquí.