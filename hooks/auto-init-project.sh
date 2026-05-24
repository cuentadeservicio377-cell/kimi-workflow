#!/bin/bash
# Auto-inicializa memoria de proyecto al iniciar sesión de Kimi
# Versión: 2.0 (2026-05-23)

read JSON
CWD=$(echo "$JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)

if [ -z "$CWD" ] || [ "$CWD" = "/" ] || [ "$CWD" = "$HOME" ]; then
    exit 0
fi

PROJECT_NAME=$(basename "$CWD")
SOURCE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:] ' '[:lower:]-')
IS_NEW_PROJECT=false

# 1. AUTO-INIT GIT
if [ ! -d "$CWD/.git" ]; then
    cd "$CWD" && git init -b main 2>/dev/null
    echo "[kimi-hook] ✅ Git inicializado" >&2
    IS_NEW_PROJECT=true
fi

# 2. DETECTAR SI ES PROYECTO NUEVO
if [ ! -f "$CWD/.kimi/memory/MEMORY.md" ]; then
    IS_NEW_PROJECT=true
elif grep -q "Ninguna registrada aún" "$CWD/.kimi/memory/MEMORY.md" 2>/dev/null; then
    IS_NEW_PROJECT=true
fi

# 3. CREAR ESTRUCTURA
mkdir -p "$CWD/.kimi/memory"

[ -f "$CWD/.gitignore" ] || cat > "$CWD/.gitignore" << 'GITEOF'
node_modules/
.venv/
__pycache__/
*.pyc
build/
dist/
.next/
.env
.env.local
.DS_Store
Thumbs.db
.vscode/
.idea/
*.swp
*.log
logs/
GITEOF

[ -f "$CWD/README.md" ] || cat > "$CWD/README.md" << EOF
# $PROJECT_NAME

> Proyecto de Kimi Code

## Descripción
_Pendiente — braindump necesario_

## Stack Técnico
_Pendiente — braindump necesario_

## Estado
- Iniciado: $(date +%Y-%m-%d)
- Fase actual: Braindump / Planificación

## Memoria
Ver [.kimi/memory/](.kimi/memory/)
