# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Añadido
- Instalación automática de dependencias (SleepWatcher, ImageSnap)
- Configuración interactiva de carpeta de destino durante la instalación
- Configuración de delay personalizable
- Script de configuración post-instalación (`wake-guard-config`)
- Logging detallado de eventos
- Soporte para iCloud Drive, Escritorio, Documentos y carpetas personalizadas
- Compatibilidad con Intel y Apple Silicon
- Script de desinstalación completa
- Detección automática de permisos de cámara
- Captura de fotos con timestamp único
- LaunchAgent para ejecución automática

### Características
- ✅ Captura automática al despertar del sleep
- ✅ Guardado configurable en múltiples ubicaciones
- ✅ Delay configurable (por defecto 3 segundos)
- ✅ Logging detallado de eventos
- ✅ Instalación/desinstalación simple
- ✅ Compatible con macOS 12.0+

### Técnico
- Uso de SleepWatcher para detectar eventos de despertar
- ImageSnap para captura de fotos
- LaunchAgent para ejecución en background
- Scripts en bash/zsh para máxima compatibilidad
- Configuración persistente en `~/.wake-guard/config`

## [Unreleased]

### Planeado
- Interfaz gráfica opcional
- Configuración de calidad de imagen
- Múltiples formatos de imagen
- Notificaciones push
- Integración con servicios de nube adicionales