---
name: project-flow
description: "Flujo end-to-end para proyectos grandes: inicia, planifica, ejecuta y cierra proyectos sin perder el foco. Trigger: /flow:project-flow o 'inicia proyecto', 'empieza feature', 'cierra proyecto'."
type: flow
---

# Project Flow — Flujo Completo de Proyecto

Flujo end-to-end para proyectos de 100+ tareas. Encadena todo: onboarding, planificación, ejecución por fases, y cierre. Nunca pierde el foco del objetivo principal.

```mermaid
flowchart TD
    BEGIN([BEGIN]) --> INIT{¿Proyecto nuevo?}
    
    INIT -->|Sí| A1[ONBOARDING: Inicializar proyecto]
    INIT -->|No| A2[RECOVER: Cargar estado anterior]
    
    A1 --> B[PLAN: Crear plan maestro]
    A2 --> B
    
    B --> C{¿Plan aprobado?}
    C -->|Rechazar| B
    C -->|Aprobar| D[SETUP: Preparar ejecución]
    
    D --> E[PHASE: Ejecutar fase actual]
    E --> F{¿Fase completa?}
    F -->|No / Bloqueada| G[PAUSE: Reportar blocker]
    G --> H{¿Usuario resuelve?}
    H -->|Sí| E
    H -->|No / Cambio| B
    
    F -->|Sí| I{¿Última fase?}
    I -->|No| J[ADVANCE: Preparar siguiente fase]
    J --> E
    
    I -->|Sí| K[VERIFY: Verificación final]
    K --> L{¿Todo pasa?}
    L -->|No| M[FIX: Corregir issues]
    M --> K
    
    L -->|Sí| N[SHIP: Cerrar proyecto]
    N --> O{¿Ship aprobado?}
    O -->|Revisar| P[REVIEW: Review final]
    P --> O
    O -->|Aprobar| END([END])
```

---

## Reglas Globales del Flujo

### 1. SCOPE LOCK (Inquebrantable)
- Durante la ejecución de CUALQUIER fase, si descubres un bug, mejora o refactor que NO está en el plan actual → NO lo toques
- Anótalo en `TODOS.md` bajo "Parking Lot"
- Continúa con la tarea actual
- ÚNICA excepción: Si el bug IMPIDE continuar la tarea actual, reporta y pide decisión

### 2. MEMORIA PERSISTENTE
- Leer `.kimi/memory/MEMORY.md` al inicio de cada fase
- Leer `.kimi/memory/PLAN.md` antes de cada tarea
- Actualizar `.kimi/memory/PROGRESS.md` después de cada fase
- Actualizar `TODOS.md` en tiempo real

### 3. DECISIONES DEL USUARIO
- Siempre presentar opciones estructuradas, nunca preguntas abiertas
- Cada decisión debe tener RECOMMENDATION clara
- Si el usuario no responde en 2 minutos en AFK mode, tomar la decisión recomendada

### 4. CHECKPOINTING
- Después de cada fase completada, hacer commit con mensaje descriptivo
- Guardar estado en `.kimi/memory/PROGRESS.md`
- Si hay error crítico, el flujo puede resumirse desde el último checkpoint
