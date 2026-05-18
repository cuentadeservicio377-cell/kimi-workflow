#!/bin/bash
# ~/.kimi/hooks/protect-sensitive.sh
# Protege archivos sensibles contra modificaciones accidentales

read JSON
FILE=$(echo "$JSON" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

if [ -z "$FILE" ]; then
    exit 0
fi

# Lista de patrones protegidos
PROTECTED_PATTERNS='\.env$\.env\.local$\.env\.production$\.env\.development$\.ssh/id_rsa\.pem$\.key$\.p12$\.pfx$'

for pattern in $PROTECTED_PATTERNS; do
    if echo "$FILE" | grep -qE "$pattern"; then
        echo "Error: Modificación directa de archivos sensibles bloqueada: $FILE" >&2
        echo "Usa herramientas específicas o edita manualmente con cuidado." >&2
        exit 2
    fi
done

exit 0
