# Verification Before Completion

## Trigger
Antes de decir "listo", "terminé", "hecho", o cualquier variante de finalización.

## Regla de Oro
**NUNCA declares trabajo completo sin verificar primero.**

## Checklist Obligatorio

### 1. Código
- [ ] Si hay tests: correrlos → deben pasar
- [ ] Si es web: verificar que carga sin errores de consola
- [ ] Si es API: probar endpoint con curl
- [ ] Si es script: ejecutar y verificar output

### 2. Git
- [ ] `git add -A`
- [ ] `git commit -m "tipo(scope): descripción"`
- [ ] No hay archivos sin commit

### 3. Memoria
- [ ] TODOS.md actualizado (tareas marcadas)
- [ ] PROGRESS.md refleja lo hecho en esta sesión
- [ ] MEMORY.md tiene decisiones nuevas si las hay

### 4. Documentación
- [ ] README actualizado si hay cambios visibles
- [ ] CHANGELOG.md tiene entrada para esta sesión

## Si Algo NO Funciona
**NO decir "listo".** Opciones:
1. Arreglar el bug ahora
2. Documentar en TODOS.md como BLOQUEO
3. Explicar claramente qué falta y por qué

## Anti-Patrones Prohibidos
- ❌ "Aquí está el código" sin verificar que funcione
- ❌ Terminar sesión con tests rotos
- ❌ Dejar TODOS.md desactualizado
- ❌ Olvidar hacer commit
