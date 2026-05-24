# Systematic Debugging

## Trigger
Cualquier bug, test fallido, error inesperado, o comportamiento anómalo.

## Protocolo

### Fase 1: Reproducir
1. ¿El error es consistente?
2. ¿Qué pasos exactos lo causan?
3. ¿Hay un test mínimo que lo reproduzca?

### Fase 2: Aislar
1. ¿Cuándo empezó a fallar? (`git bisect` o revisar últimos commits)
2. ¿Qué archivo/módulo/función es el culpable?
3. ¿Qué cambio lo introdujo?

### Fase 3: Hipótesis
1. Formular 2-3 hipótesis de causa raíz
2. Para cada una: ¿qué evidencia la confirma o refuta?
3. Priorizar la más simple (Occam's razor)

### Fase 4: Verificar
1. Hacer el cambio mínimo que pruebe la hipótesis
2. Reproducir el escenario
3. ¿El error desaparece?

### Fase 5: Arreglar
1. Implementar fix mínimo y correcto
2. Añadir test de regresión
3. Verificar que no rompe otra cosa

### Fase 6: Documentar
1. Documentar la causa raíz en MEMORY.md
2. Si es un gotcha, añadir a AGENTS.md
3. Actualizar TODOS.md si quedan deudas técnicas

## Reglas
- NO arreglar síntomas sin entender causa raíz
- NO hacer cambios grandes sin test de reproducción
- SIEMPRE añadir test de regresión
- SIEMPRE verificar que el fix no introduce nuevos bugs
