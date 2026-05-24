# Braindump Init — Inicio Automático de Proyectos Nuevos

## Trigger

Detecta archivo `.kimi/NEW_PROJECT` en el directorio de trabajo actual.

## Cuándo usar

AL INICIO de cada sesión, después de leer `.kimi/memory/.session-init.json`.

## Flujo

### Paso 1: Detectar
```bash
if [ -f ".kimi/NEW_PROJECT" ]; then
    # Es un proyecto nuevo
fi
```

### Paso 2: Leer preguntas
Leer `.kimi/NEW_PROJECT` para obtener las 7 preguntas del braindump.

### Paso 3: Preguntar al usuario
Presentar las preguntas UNA POR UNA o en bloque, según preferencia del usuario.

**Formato de presentación:**

```
🧠 Proyecto NUEVO detectado: [nombre]

Veo que acabas de crear este proyecto. Para poder ayudarte bien, necesito un braindump.

Preguntas (responde las que quieras, puedes saltar las que no apliquen):

1. ¿Qué es este proyecto?
2. ¿Quién lo usa?
3. ¿Qué stack tecnológico prefieres?
4. ¿Hay deadline o prioridad?
5. ¿Hay algo ya construido?
6. ¿Restricciones importantes?
7. ¿Qué haría que sea un éxito?

Responde directamente — puedes ser breve o detallado.
```

### Paso 4: Guardar respuestas
Después de recibir respuestas:

1. Actualizar `.kimi/memory/MEMORY.md` con el braindump
2. Actualizar `README.md` con descripción y stack
3. Crear `.kimi/memory/PLAN.md` con plan inicial basado en braindump
4. Actualizar `TODOS.md` con tareas iniciales
5. Guardar en gbrain via `put_page` (async)
6. Eliminar `.kimi/NEW_PROJECT` (braindump completado)
7. Hacer commit inicial: `git add -A && git commit -m "chore: braindump + estructura inicial"`

### Paso 5: Confirmar
```
✅ Braindump guardado. Memoria inicializada.

Resumen:
- Descripción: [1 línea]
- Stack: [stack]
- Plan: [N fases definidas]
- Próxima tarea: [primera tarea]

¿Empezamos con la primera tarea o quieres ajustar el plan?
```

## Anti-patrones

- ❌ NO crear código antes del braindump
- ❌ NO asumir stack sin preguntar
- ❌ NO saltar el braindump a menos que el usuario diga explícitamente "saltar"
- ❌ NO eliminar `.kimi/NEW_PROJECT` sin guardar las respuestas

## Integración con gbrain

Después de guardar el braindump:

```bash
# Guardar braindump en gbrain
python3 "/Users/pablomeneses/.kimi/skills/gbrain-local/gbrain-wrapper.py" put \
    "[source-name]/braindump" \
    < ".kimi/memory/MEMORY.md"
```
