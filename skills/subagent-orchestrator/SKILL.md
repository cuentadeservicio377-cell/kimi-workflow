---
name: subagent-orchestrator
description: "Orquesta subagentes paralelos para proyectos grandes. Divide el trabajo en tareas independientes, ejecuta en paralelo con Agent tool, integra resultados. Usar para proyectos 100+ tareas o cuando haya módulos desacoplados."
---

# Subagent Orchestrator

## Cuándo Usar

- Proyectos con 100+ tareas
- Múltiples módulos independientes (frontend, backend, infra)
- Tareas que no comparten estado (ej: crear componente A vs componente B)
- Análisis de codebase grande antes de modificar

## Filosofía

**Divide y vencerás, pero con integración.**

En lugar de una sesión monolítica que satura el contexto:
1. Dividir el plan en "work packages" independientes
2. Ejecutar cada uno en un subagente paralelo
3. Integrar los resultados
4. Verificar que todo funciona junto

## Workflow

### Paso 1: Análisis de Divisibilidad

Antes de dividir, analizar el plan:

```
¿Estas tareas son realmente independientes?
- ¿Comparten archivos? → NO dividir
- ¿Tienen dependencias de datos? → Ordenar, no paralelizar
- ¿Son puramente lectura/análisis? → Sí, paralelizar
- ¿Son implementaciones en módulos diferentes? → Sí, paralelizar
```

### Paso 2: Crear Work Packages

Cada work package debe tener:
```markdown
## Work Package N: [Nombre]

**Objetivo:** Una oración clara
**Input:** Qué necesita saber (archivos, contexto)
**Output:** Qué debe producir (archivos, funciones)
**Restricciones:** Qué NO debe tocar
**Tests:** Cómo verificar que funciona
```

### Paso 3: Ejecutar Subagentes

```
# Ejemplo: 3 work packages en paralelo

Agent 1 (explore): Analizar codebase actual → Mapa de archivos
Agent 2 (plan): Diseñar API endpoints → Spec de API
Agent 3 (coder): Implementar componente UI → Componente funcionando
```

**Reglas para subagentes:**
- Cada uno recibe SU plan, no el plan completo
- Ningún subagente puede crear subagentes anidados
- Timeout por subagente: 15 min (background) o ilimitado (foreground)
- El agente padre integra resultados

### Paso 4: Integración

Después de que todos los subagentes terminen:
1. Verificar que los outputs no conflictúan (mismo archivo modificado)
2. Integrar cambios en el orden correcto
3. Correr tests de integración
4. Si hay conflictos, resolver con subagente adicional o manualmente

### Paso 5: Checkpoint

Commit: `feat: integrate work packages [X, Y, Z]`

## Ejemplo Práctico

**Proyecto:** Sistema de e-commerce (150 tareas)

```
Fase 1: Foundation (no paralelizable)
├── Setup proyecto
├── Configurar DB
└── Autenticación básica

Fase 2: Módulos Core (paralelizable)
├── WP1: Catálogo de productos → 3 subagentes
├── WP2: Carrito de compras → 2 subagentes
├── WP3: Checkout y pagos → 2 subagentes
└── WP4: Panel de admin → 2 subagentes

Fase 3: Integración (no paralelizable)
├── Unir todos los módulos
├── Tests end-to-end
└── Optimización
```

## Anti-Patterns

- ❌ Dividir tareas que comparten el mismo archivo
- ❌ Más de 4 subagentes en paralelo (saturación)
- ❌ Subagentes sin output definido
- ❌ No verificar integración después de paralelizar
- ✅ Dividir por módulos/feature boundaries
- ✅ Max 4 subagentes paralelos
- ✅ Output claro y verificable por cada subagente
- ✅ Siempre integrar y testear después
