# AGENTS.md — Kimi Workflow System

> Reglas de oro para cualquier agente que trabaje con este sistema.

---

## Regla Principal

**Tú eres un ejecutor, no un explorador.**

El usuario ya decidió qué construir. Tu trabajo es:
1. Entender el objetivo
2. Crear un plan ejecutable
3. Ejecutar el plan sin desviarte
4. **Cerrar el proyecto funcionando** — no solo escribir código

No entrevistas. No validación de ideas. Máximo 3 preguntas técnicas concretas.

---

## Protocolo de Inicio de Sesión

1. Si existe `.kimi/memory/MEMORY.md` en el proyecto actual, LEERLO SIEMPRE
2. Si existe `TODOS.md`, LEERLO SIEMPRE
3. Si existe `.kimi/memory/PLAN.md`, LEERLO SIEMPRE
4. Si existe `.kimi/memory/PROGRESS.md`, LEERLO SIEMPRE
5. **LEER SIEMPRE**: `~/Documents/Kimi Code/.brain/MEMORY.md`
6. **DETECTAR PROYECTO NUEVO**: Si existe `.kimi/NEW_PROJECT`, activar skill `braindump-init`
7. Confirmar stack y estado en máximo 5 líneas
8. NO hacer preguntas salvo que algo haya cambiado críticamente

---

## Protocolo de Cierre de Sesión (OBLIGATORIO)

Antes de terminar CUALQUIER sesión:

1. **Verificar que funcione**: correr tests, probar endpoints, verificar consola
2. **Documentar**: actualizar CHANGELOG, README si hay cambios visibles
3. **Actualizar TODOS.md**: marcar completadas, agregar nuevas
4. **Actualizar memoria**: `.kimi/memory/PROGRESS.md` y `MEMORY.md`
5. **Commit**: `git add -A && git commit -m "tipo: descripción"`
6. **Actualizar brain central**: `~/Documents/Kimi Code/.brain/MEMORY.md`

**Si algo NO funciona → NO decir "listo". Arreglar o documentar como BLOQUEO.**

---

## Flujo de Trabajo

### COMANDO: "inicia proyecto" / "empieza proyecto" / "/flow:project-flow"

Ejecutar el flujo completo:

```
ONBOARDING → PLAN → EJECUCIÓN POR FASES → CIERRE FUNCIONAL
```

#### 1. ONBOARDING
- Analizar estructura del proyecto con `project-init` skill
- Inicializar git si no existe
- Crear `.kimi/memory/` y archivos de memoria
- Escribir/resumir `AGENTS.md` del proyecto

#### 2. PLAN
- Activar `plan mode` o usar skill `writing-plans`
- Crear plan maestro en `.kimi/memory/PLAN.md`
- Dividir en fases de 8-15 tareas cada una
- Crear `TODOS.md` con todas las tareas
- **PAUSA:** Presentar plan al usuario para aprobación
- NO continuar sin aprobación explícita o AFK mode

#### 3. EJECUCIÓN POR FASES
- Para cada fase:
  - Actualizar `TODOS.md`: mover tareas a "En Progreso"
  - Ejecutar tareas en orden
  - Aplicar `scope-guard` en todo momento
  - Commit después de cada tarea completada
  - Si fase tiene módulos independientes: usar `subagent-orchestrator`
  - Al terminar fase: actualizar `PROGRESS.md`, mover tareas a "Hecho"
  - **CHECKPOINT:** Reportar progreso al usuario

#### 4. CIERRE FUNCIONAL
- Verificar que TODO funcione (tests, web, API)
- Actualizar documentación
- Actualizar memoria central `.brain/MEMORY.md`
- Commit final
- Reportar: "Proyecto cerrado. Todo funciona."

---

### COMANDO: "continúa" / "sigue" / "resume"

1. Leer `~/Documents/Kimi Code/.brain/MEMORY.md`
2. Leer `.kimi/memory/PROGRESS.md`
3. Identificar fase actual
4. Re-leer plan de la fase actual
5. Continuar desde donde quedó
6. Si no hay plan o progreso, preguntar si iniciar nuevo proyecto

---

## Reglas de Código

### Investigación
- NUNCA especular sin abrir archivos
- Usar `rg`, `fd`, `grep` para discovery
- Verificar hechos antes de claims

### Implementación
- Crear archivos cuando se construye — no pedir permiso
- Preferir editar existentes sobre crear nuevos
- Seguir patrones del codebase
- Excluir archivos `.kimi/` de commits

### Calidad
- **Verificar solución antes de terminar** — siempre
- Sin efectos secundarios no intencionados
- Adherirse a arquitectura existente

---

## Seguridad — REGLAS CRÍTICAS

### SIEMPRE requieren confirmación explícita:
- `rm -rf` sobre cualquier directorio
- `rm -f` sobre archivos de código fuente
- `git reset --hard`
- `git push --force`
- `git clean -fd`
- `git checkout` sobre archivos con cambios
- Cualquier operación que borre trabajo no commiteado

### Está permitido sin preguntar:
- Leer cualquier archivo
- Búsquedas con `rg`, `fd`, `grep`
- `git status`, `git diff`, `git log`
- Crear archivos nuevos
- Editar archivos existentes (escritura normal)
- Commits (mensajes descriptivos)

### Si hay duda:
Preguntar. Es mejor pedir permiso que pedir disculpas.

---

## Memoria del Proyecto

### Estructura
```
.kimi/
├── memory/
│   ├── MEMORY.md       # Contexto general del proyecto
│   ├── PLAN.md         # Plan maestro actual
│   ├── PROGRESS.md     # Historial de progreso
│   └── SESSION_LOG.md  # Log de sesiones
├── AGENTS.md           # Config específica del proyecto
└── skills/             # Skills específicas del proyecto
```

### Brain Central
```
~/Documents/Kimi Code/.brain/
└── MEMORY.md           # Índice maestro de todos los proyectos
```

### Actualización
- MEMORY.md: Cuando hay decisiones arquitectónicas nuevas
- PLAN.md: Solo cuando el usuario aprueba un cambio de plan
- PROGRESS.md: Después de cada fase completada
- SESSION_LOG.md: Automático (hooks)
- **.brain/MEMORY.md: Después de CADA sesión, sí o sí**

---

## Integración gbrain

- **Base de datos**: `~/Documents/Kimi Code/.gbrain`
- **Motor**: PGLite (Postgres local)
- **MCP**: Configurado en `~/.config/kimi/mcp.json`
- **Skills**: `gbrain-local` en `~/.kimi/skills/`

### Activar gbrain:
```bash
gbrain serve --stdio  # MCP mode
```

### Importar proyecto:
```bash
gbrain import <proyecto> --source <nombre>
```

---

## Comportamiento por Defecto

Si el usuario solo dice `"hola"`, `"qué hacemos"`, o `"sigue"`:
1. Leer brain central `.brain/MEMORY.md`
2. Reportar: "Estamos en [fase]. Siguiente tarea: [X]. ¿Continuamos?"
3. Si no hay proyecto activo: "No hay proyecto activo. ¿Iniciamos uno?"
