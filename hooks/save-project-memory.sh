#!/bin/bash
# ~/.kimi/hooks/save-project-memory.sh
# Guarda estado de la sesión en memoria del proyecto al cerrar

read JSON
CWD=$(echo "$JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)
REASON=$(echo "$JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('reason','unknown'))" 2>/dev/null)

if [ -z "$CWD" ] || [ ! -d "$CWD/.kimi/memory" ]; then
    exit 0
fi

# Actualizar fecha de última sesión
if [ -f "$CWD/.kimi/memory/MEMORY.md" ]; then
    sed -i.bak "s/Última sesión:.*/Última sesión: $(date +%Y-%m-%d %H:%M)/" "$CWD/.kimi/memory/MEMORY.md" 2>/dev/null
    rm -f "$CWD/.kimi/memory/MEMORY.md.bak"
fi

# Log de cierre de sesión
echo "- $(date '+%Y-%m-%d %H:%M') | Sesión cerrada: $REASON" >> "$CWD/.kimi/memory/SESSION_LOG.md" 2>/dev/null

exit 0
