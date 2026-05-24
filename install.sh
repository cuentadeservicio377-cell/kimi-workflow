#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIMI_DIR="$HOME/.kimi"
CONFIG_DIR="$HOME/.config/kimi"
PROJECTS_DIR="$HOME/Documents/Kimi Code"
BRAIN_DIR="$PROJECTS_DIR/.brain"
GBRAIN_DIR="$PROJECTS_DIR/.gbrain"

echo "============================================"
echo "  Kimi Workflow — Instalador Automático"
echo "============================================"
echo ""

# 1. Crear directorios base
echo "📁 Creando directorios..."
mkdir -p "$KIMI_DIR/hooks"
mkdir -p "$KIMI_DIR/skills"
mkdir -p "$CONFIG_DIR"
mkdir -p "$BRAIN_DIR"
mkdir -p "$GBRAIN_DIR"

# 2. Copiar config.toml
echo "⚙️  Instalando config.toml..."
cp "$SCRIPT_DIR/config.toml" "$KIMI_DIR/config.toml"

# 3. Copiar mcp.json
echo "🔗 Instalando mcp.json..."
cp "$SCRIPT_DIR/mcp.json" "$CONFIG_DIR/mcp.json"

# 4. Copiar gbrain-config.json template
echo "🧠 Instalando gbrain-config.json..."
cp "$SCRIPT_DIR/gbrain-config.json" "$GBRAIN_DIR/config.json"

# 5. Copiar hooks
echo "🪝 Instalando hooks..."
cp "$SCRIPT_DIR/hooks/"*.sh "$KIMI_DIR/hooks/"
chmod +x "$KIMI_DIR/hooks/"*.sh

# 6. Copiar skills
echo "🎯 Instalando skills..."
for skill_dir in "$SCRIPT_DIR/skills/"*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        mkdir -p "$KIMI_DIR/skills/$skill_name"
        cp "$skill_dir/"* "$KIMI_DIR/skills/$skill_name/"
        echo "   ✅ $skill_name"
    fi
done

# 7. Crear brain central si no existe
if [ ! -f "$BRAIN_DIR/MEMORY.md" ]; then
    echo "🧠 Creando brain central..."
    cp "$SCRIPT_DIR/templates/brain-central/MEMORY.md" "$BRAIN_DIR/MEMORY.md"
    # Reemplazar placeholders
    sed -i.bak "s/{DATE}/$(date +%Y-%m-%d)/g" "$BRAIN_DIR/MEMORY.md" 2>/dev/null || true
    rm -f "$BRAIN_DIR/MEMORY.md.bak"
fi

echo ""
echo "============================================"
echo "  ✅ Instalación completa"
echo "============================================"
echo ""
echo "Próximos pasos:"
echo ""
echo "1. Instalar Ollama:"
echo "   brew install ollama"
echo "   ollama pull nomic-embed-text"
echo ""
echo "2. Instalar gbrain:"
echo "   bun install -g gbrain   # o npm install -g gbrain"
echo ""
echo "3. Inicializar gbrain:"
echo "   export GB_CONFIG_PATH=\"$GBRAIN_DIR/config.json\""
echo "   gbrain init --pglite --embedding-model ollama:nomic-embed-text --embedding-dimensions 768"
echo ""
echo "4. Verificar:"
echo "   gbrain doctor --json"
echo "   ollama list"
echo ""
echo "5. Leer INSTALL.md para guía completa:"
echo "   cat $SCRIPT_DIR/INSTALL.md"
echo ""
echo "============================================"
