---
name: scope-guard
description: "Protege contra scope creep y distracciones durante la ejecución de proyectos grandes. Usar cuando Codex/Kimi empiece a desviarse del plan, ver bugs secundarios, o proponer refactors no planificados."
---

# Scope Guard — Protección Contra Scope Creep

## Propósito

Mantener al agente enfocado en el objetivo actual. Prevenir que:
- Se distraiga arreglando bugs no relacionados
- Proponga refactors que no están en el plan
- Se meta en rabbit holes técnicos
- Cambie el plan sin autorización explícita

## Reglas de Oro

### 1. La Tarea Actual es Sagrada
- Solo se trabaja en lo que está en `TODOS.md` → "En Progreso"
- Todo lo demás está bloqueado hasta nuevo aviso

### 2. El Parking Lot es tu Mejor Amigo

Cuando descubras algo que NO está en el plan:

```
PASO 1: NO toques el código
PASO 2: Escribe en TODOS.md → Parking Lot:
- [ ] [SEVERIDAD] Descripción del issue descubierto
  - Dónde: archivo/función
  - Impacto: qué podría romper
  - Por qué no se arregla ahora: razón
PASO 3: Reporta al usuario al final de la fase
PASO 4: Continúa con la tarea actual
```

### 3. Jerarquía de Decisiones

| Situación | Acción |
|-----------|--------|
| Bug crítico que IMPIDE la tarea actual | STOP → Reportar → Esperar decisión |
| Bug no crítico en código relacionado | Parking Lot → Continuar |
| Mejora de performance visible | Parking Lot → Continuar |
| Refactor que "quedaría mejor" | Parking Lot → Continuar |
| Error de seguridad (SQL injection, XSS) | STOP → Reportar inmediatamente |
| Dependencia faltante del plan | STOP → Reportar → Esperar decisión |

### 4. Re-lectura Forzada

Cada 5 tareas completadas (o cada 30 minutos), RE-LEER:
1. `.kimi/memory/PLAN.md` — ¿Vamos por buen camino?
2. `TODOS.md` — ¿Qué sigue?
3. Si hay desviación > 20%, REPORTAR al usuario

### 5. Anti-Patterns Bloqueados

- ❌ "Mientras estoy aquí, arreglo esto también..."
- ❌ "Veo que esto podría refactorizarse..."
- ❌ "Este patrón no es ideal, deberíamos cambiarlo..."
- ❌ "Hay un bug en esta otra función..."
- ✅ "Anotado en Parking Lot. Continúo con [tarea actual]."

## Comando de Recuperación

Si el agente se pierde, el usuario puede decir:
- `"scope check"` → Revisar si estamos en scope
- `"parking lot"` → Mostrar todo lo que se ha pospuesto
- `"back to plan"` → Abandonar lo que se esté haciendo y volver al plan
- `"reset focus"` → Leer plan, olvidar distracciones, continuar
