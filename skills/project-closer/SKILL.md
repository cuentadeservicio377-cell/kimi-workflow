# Project Closer — Cierre Garantizado

## Propósito

Evitar que Kimi deje proyectos a medias. Cada sesión debe terminar con código funcional, no solo escrito.

## Checklist de Cierre Obligatorio

Antes de decir "listo" o "terminé":

### 1. Verificación Funcional
- [ ] Si hay tests: correrlos → deben pasar
- [ ] Si es web: verificar que carga sin errores en consola
- [ ] Si es API: probar endpoint con curl o similar
- [ ] Si es script: ejecutar y verificar output

### 2. Documentación
- [ ] ¿Cambió algo que el usuario necesita saber? → README
- [ ] ¿Hay nueva funcionalidad? → CHANGELOG.md
- [ ] ¿Cambió la arquitectura? → `.kimi/memory/MEMORY.md`

### 3. Estado del Proyecto
- [ ] `TODOS.md`: marcar completadas, agregar nuevas
- [ ] `.kimi/memory/PROGRESS.md`: resumen de esta sesión
- [ ] `.kimi/memory/MEMORY.md`: decisiones nuevas, gotchas
- [ ] **gbrain**: guardar estado con `put_page` si es relevante

### 4. Git
- [ ] `git add -A`
- [ ] `git commit -m "tipo(scope): descripción clara"`

### 5. Memoria Central
- [ ] Actualizar `/Users/pablomeneses/Documents/Kimi Code/.brain/MEMORY.md`

## Si Algo NO Funciona

**NO decir "listo".** Opciones:
1. Arreglar el bug ahora
2. Documentar el bug en TODOS.md como "BLOQUEO"
3. Explicar claramente qué falta y por qué

## Anti-Patrones Prohibidos

- ❌ "Aquí está el código" sin verificar que funcione
- ❌ Terminar sesión con tests rotos
- ❌ Dejar TODOS.md desactualizado
- ❌ Olvidar hacer commit
- ❌ No guardar memoria en gbrain
