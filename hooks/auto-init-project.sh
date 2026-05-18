#!/bin/bash
# ~/.kimi/hooks/auto-init-project.sh
# Auto-inicializa git y memoria de proyecto al iniciar sesión de Kimi

read JSON
CWD=$(echo "$JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)

if [ -z "$CWD" ] || [ "$CWD" = "/" ] || [ "$CWD" = "$HOME" ]; then
    exit 0
fi

# ─── 1. AUTO-INIT GIT ────────────────────────────────────────────────────────
if [ ! -d "$CWD/.git" ]; then
    cd "$CWD" && git init -b main 2>/dev/null
    echo "[kimi-hook] Git inicializado en $CWD" >&2
fi

# ─── 2. CREAR ESTRUCTURA DE MEMORIA ──────────────────────────────────────────
mkdir -p "$CWD/.kimi/memory"

# MEMORY.md - índice de memoria del proyecto
if [ ! -f "$CWD/.kimi/memory/MEMORY.md" ]; then
    cat > "$CWD/.kimi/memory/MEMORY.md" << 'EOF'
# Memoria del Proyecto

> Este archivo es mantenido automáticamente por Kimi.
> No editar manualmente a menos que sepas lo que haces.

## Contexto Actual
- Proyecto iniciado: $(date +%Y-%m-%d)
- Última sesión: $(date +%Y-%m-%d)

## Decisiones Arquitectónicas
- Ninguna registrada aún

## APIs / Integraciones
- Ninguna registrada aún

## Gotchas Conocidos
- Ninguno registrado aún
EOF
fi

# TODOS.md - tracking de tareas
if [ ! -f "$CWD/TODOS.md" ]; then
    cat > "$CWD/TODOS.md" << 'EOF'
# TODOS

## En Progreso
_Empty — se actualiza durante la sesión_

## Pendientes
_Empty — se actualiza durante la sesión_

## Parking Lot (NO tocar ahora)
_Cosas descubiertas durante el desarrollo que NO están en el plan actual_

## Hecho
_Empty — se actualiza durante la sesión_
EOF
fi

# PLAN.md - plan actual
if [ ! -f "$CWD/.kimi/memory/PLAN.md" ]; then
    cat > "$CWD/.kimi/memory/PLAN.md" << 'EOF'
# Plan Actual

> Estado: SIN PLAN — Usa /flow:project-flow para iniciar un proyecto
EOF
fi

# PROGRESS.md - progreso
if [ ! -f "$CWD/.kimi/memory/PROGRESS.md" ]; then
    cat > "$CWD/.kimi/memory/PROGRESS.md" << 'EOF'
# Progreso

## Historial de Sesiones

## Features Completadas

## Bloqueadores Resueltos
EOF
fi

exit 0
