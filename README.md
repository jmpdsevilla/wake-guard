# Wake Guard - Monitor de Acceso para MacBook

Herramienta de seguridad para macOS que **detecta automáticamente cuando alguien abre tu MacBook** mientras está suspendido. Toma fotos silenciosas de intrusos **incluso si no pueden acceder al sistema**, perfecto para detectar curiosos en viajes, oficinas compartidas o espacios públicos.

## ¿Qué hace exactamente?

**Escenario típico:**
1. Dejas tu MacBook cerrado y suspendido en una mesa
2. Alguien lo abre por curiosidad (aunque tenga contraseña y no pueda entrar)
3. Wake Guard **detecta instantáneamente** que se abrió la tapa
4. **Captura una foto silenciosa** del intruso usando la cámara frontal
5. Guarda la evidencia con fecha y hora en tu carpeta elegida

**Todo sucede en segundos, de forma invisible y sin alertar al intruso.**

## Instalación Rápida

```bash
curl -fsSL https://raw.githubusercontent.com/jmpdsevilla/wake-guard/main/install.sh | bash
```

## Instalación Manual

1. Clona el repositorio:
```bash
git clone https://github.com/jmpdsevilla/wake-guard.git
cd wake-guard
```

2. Ejecuta el instalador:
```bash
./install.sh
```

## Características Principales

- **Detección automática** al abrir la tapa del MacBook
- **Captura silenciosa** - El intruso no sabe que fue fotografiado
- **Sin necesidad de login** - Funciona aunque no puedan acceder al sistema
- **Múltiples ubicaciones** de guardado (iCloud, Escritorio, Documentos, personalizada)
- **Registro completo** de todos los eventos con fecha y hora
- **Instalación simple** en un solo comando
- **Compatible** con MacBook Intel y Apple Silicon (M1/M2/M3/M4)

## Requisitos del Sistema

- macOS 12.0 (Monterey) o superior
- MacBook con cámara frontal integrada
- Homebrew (se instala automáticamente si no existe)
- Permisos de cámara (se solicitan durante la instalación)

## Cómo Funciona

Wake Guard utiliza **SleepWatcher** para monitorear el estado de suspensión de tu MacBook:

1. **Estado suspendido**: MacBook cerrado, sistema dormido
2. **Detección de despertar**: Alguien abre la tapa
3. **Captura inmediata**: Foto silenciosa después de 3 segundos (configurable)
4. **Almacenamiento seguro**: Imagen guardada con timestamp único

### Comandos Útiles

**Configurar ubicación y delay:**
```bash
wake-guard-config
```

**Ver registros de actividad:**
```bash
tail -f ~/Library/Logs/wake-guard.log
```

**Estado del servicio:**
```bash
brew services list | grep sleepwatcher
```

**Desinstalar completamente:**
```bash
curl -fsSL https://raw.githubusercontent.com/jmpdsevilla/wake-guard/main/uninstall.sh | bash
```

## Casos de Uso Comunes

- **Viajeros de negocios** - Hoteles, aeropuertos, cafeterías
- **Estudiantes** - Bibliotecas, residencias, aulas
- **Trabajadores remotos** - Coworkings, espacios compartidos
- **Oficinas** - Detectar acceso no autorizado durante ausencias
- **Hogares** - Monitorear uso por familiares o visitantes

## Privacidad y Seguridad

- **Almacenamiento local**: Todas las fotos permanecen en tu dispositivo o iCloud personal
- **Sin servidores externos**: Ningún dato se envía a terceros
- **Código abierto**: Puedes revisar exactamente qué hace el software
- **Uso responsable**: Solo para equipos propios, incluye advertencias legales
- **Control total**: Puedes activar/desactivar cuando quieras

## Solución de Problemas

¿No funciona correctamente? Ver [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

**Problemas más comunes:**
- Permisos de cámara denegados
- SleepWatcher no se inicia automáticamente
- Fotos no aparecen en la ubicación esperada

## Contribuir al Proyecto

¡Las contribuciones son bienvenidas! Ver [CONTRIBUTING.md](docs/CONTRIBUTING.md)

**Formas de ayudar:**
- Reportar bugs encontrados
- Sugerir nuevas características
- Mejorar la documentación
- Probar en diferentes versiones de macOS

## Licencia

MIT License - ver [LICENSE](LICENSE)

Esto significa que puedes usar, modificar y distribuir el código libremente.

## Autor

**Jose Manuel Perez** ([@jmpdsevilla](https://github.com/jmpdsevilla))



## ¿Te ha sido útil Wake Guard?

Si este proyecto te ha ayudado a detectar accesos no autorizados o simplemente te parece una herramienta útil:

- Dale una estrella ⭐ en GitHub
- Compártelo con otros usuarios de Mac
- Contribuye con mejoras o reporta bugs
- Déjanos saber tu experiencia en los Issues

