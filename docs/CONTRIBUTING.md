# Guía de Contribución

¡Gracias por tu interés en contribuir a Wake Guard! 🎉

## 🚀 Cómo Contribuir

### Reportar Bugs

1. Verifica que el bug no haya sido reportado anteriormente en [Issues](https://github.com/jmpdsevilla/wake-guard/issues)
2. Crea un nuevo issue usando el template de bug report
3. Incluye toda la información solicitada en el template

### Sugerir Nuevas Características

1. Verifica que la característica no haya sido sugerida anteriormente
2. Crea un nuevo issue usando el template de feature request
3. Describe claramente el problema que resuelve y cómo lo haría

### Contribuir Código

1. **Fork** el repositorio
2. Crea una **rama** para tu característica (`git checkout -b feature/nueva-caracteristica`)
3. **Commitea** tus cambios (`git commit -am 'Añadir nueva característica'`)
4. **Push** a la rama (`git push origin feature/nueva-caracteristica`)
5. Crea un **Pull Request**

## 📋 Estándares de Código

### Shell Scripts

- Usar `#!/bin/bash` o `#!/bin/zsh` según corresponda
- Incluir `set -euo pipefail` para manejo de errores
- Usar comillas dobles para variables: `"$VARIABLE"`
- Comentar funciones complejas
- Seguir el estilo de código existente

### Estructura de Commits

```
tipo(alcance): descripción breve

Descripción más detallada si es necesaria.

- Cambio específico 1
- Cambio específico 2
```

**Tipos de commit:**
- `feat`: Nueva característica
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Cambios de formato (no afectan funcionalidad)
- `refactor`: Refactorización de código
- `test`: Añadir o modificar tests
- `chore`: Tareas de mantenimiento

## 🧪 Testing

Antes de enviar un PR:

1. Prueba la instalación en un Mac limpio
2. Verifica que la desinstalación funcione correctamente
3. Prueba en Intel y Apple Silicon si es posible
4. Verifica que los logs se generen correctamente

## 📝 Documentación

- Actualiza el README.md si añades nuevas características
- Actualiza CHANGELOG.md con tus cambios
- Documenta nuevas opciones de configuración
- Incluye ejemplos de uso si es relevante

## 🔒 Consideraciones de Seguridad

- No incluyas credenciales o información sensible
- Verifica que los permisos de archivos sean correctos
- Considera las implicaciones de privacidad de nuevas características
- Documenta cualquier nuevo permiso requerido

## 🐛 Debugging

### Logs Útiles

```bash
# Ver logs de Wake Guard
tail -f ~/Library/Logs/wake-guard.log

# Ver estado de LaunchAgent
launchctl list | grep sleepwatcher

# Verificar permisos de cámara
tccutil reset Camera
```

### Problemas Comunes

1. **SleepWatcher no se ejecuta**: Verificar LaunchAgent
2. **No se capturan fotos**: Verificar permisos de cámara
3. **Carpeta no existe**: Verificar permisos de escritura

## 📞 Contacto

- Crea un issue para preguntas técnicas
- Usa discussions para preguntas generales
- Revisa la documentación existente antes de preguntar

## 📄 Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo la MIT License.