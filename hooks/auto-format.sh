#!/bin/bash
# ~/.kimi/hooks/auto-format.sh
# Formateo automático después de escribir archivos

read JSON
FILE=$(echo "$JSON" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
    exit 0
fi

# Prettier para JS/TS/CSS/HTML/JSON
if echo "$FILE" | grep -qE '\.(js|jsx|ts|tsx|css|scss|html|json|md|yaml|yml)$'; then
    if command -v prettier >/dev/null 2>&1; then
        prettier --write "$FILE" 2>/dev/null
    elif command -v npx >/dev/null 2>&1; then
        npx prettier --write "$FILE" 2>/dev/null
    fi
fi

# Black para Python
if echo "$FILE" | grep -qE '\.py$'; then
    if command -v black >/dev/null 2>&1; then
        black "$FILE" 2>/dev/null
    fi
fi

# gofmt para Go
if echo "$FILE" | grep -qE '\.go$'; then
    if command -v gofmt >/dev/null 2>&1; then
        gofmt -w "$FILE" 2>/dev/null
    fi
fi

exit 0
