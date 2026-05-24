#!/bin/bash
# Hook de cierre de sesión: commit + memoria + verificación
# Versión: 2.0 (2026-05-23)

read JSON
CWD=$(echo "$JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)
REASON=$(echo "$JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('reason','unknown'))" 2>/dev/null)
[ -z "$CWD" ] || [ ! -d "$CWD/.git" ] && exit 0

cd "$CWD" || exit 0
PROJECT_NAME=$(basename "$CWD")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
DATEONLY=$(date +%Y-%m-%d)
SOURCE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:] ' '[:lower:]-')

# 1. DETECTAR ARCHIVOS MODIFICADOS
CHANGED=$(git status --short 2>/dev/null | wc -l | tr -d ' ')

if [ "$CHANGED" -gt 0 ]; then
    echo "[kimi-close] 🔧 $CHANGED archivos modificados en $PROJECT_NAME" >&2

    # 2. VERIFICAR QUE NO HAYA ARCHIVOS SENSIBLES
    if git diff --cached --name-only 2>/dev/null | grep -qiE '\.env|secret|password|token|key'; then
        echo "[kimi-close] ⚠️  Posibles archivos sensibles detectados — NO se hará auto-commit" >&2
    else
        # 3. AUTO-COMMIT
        git add -A
        git commit -m "session($SOURCE_NAME): cambios de sesión $DATEONLY" --no-verify 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "[kimi-close] ✅ Commit realizado" >&2
        else
            echo "[kimi-close] ⚠️  Falló el commit" >&2
        fi
    fi
else
    echo "[kimi-close] ℹ️  Sin cambios para commitear" >&2
fi

# 4. ACTUALIZAR MEMORIA LOCAL
if [ -f "$CWD/.kimi/memory/MEMORY.md" ]; then
    sed -i.bak "s/Última sesión:.*/Última sesión: $TIMESTAMP/" "$CWD/.kimi/memory/MEMORY.md" 2>/dev/null
    rm -f "$CWD/.kimi/memory/MEMORY.md.bak"
fi

if [ -f "$CWD/.kimi/memory/SESSION_LOG.md" ]; then
    echo "- $TIMESTAMP | Sesión cerrada: $REASON | Archivos: $CHANGED" >> "$CWD/.kimi/memory/SESSION_LOG.md"
else
    echo "# Log de Sesiones

- $TIMESTAMP | Sesión cerrada: $REASON | Archivos: $CHANGED" > "$CWD/.kimi/memory/SESSION_LOG.md"
fi

# 5. BRAIN CENTRAL
BRAIN="$HOME/Documents/Kimi Code/.brain/MEMORY.md"
if [ -f "$BRAIN" ]; then
    sed -i.bak "s/Última actualización:.*/Última actualización: $DATEONLY/" "$BRAIN" 2>/dev/null
    rm -f "$BRAIN.bak"
fi

# 6. GBRAIN ASYNC (no bloquea)
if command -v gbrain >/dev/null 2>&1 && [ -d "$HOME/Documents/Kimi Code/.gbrain" ]; then
    (
        cd "$HOME/Documents/Kimi Code"
        PAGE_SLUG="$SOURCE_NAME/session-$(date +%Y%m%d-%H%M)"
        echo "# Sesión $PROJECT_NAME — $TIMESTAMP

## Estado de Cierre
- **Razón**: $REASON
- **Archivos modificados**: $CHANGED
- **Commit**: $(cd "$CWD" && git log -1 --oneline 2>/dev/null || echo 'N/A')
" | gbrain put "$PAGE_SLUG" >/dev/null 2>&1
    ) &
fi

echo "[kimi-close] 🔒 Cierre completado" >&2
exit 0
