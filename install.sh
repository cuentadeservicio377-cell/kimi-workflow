#!/bin/bash
# install.sh — Instalador automático del Kimi Workflow
# Uso: bash install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
KIMI_DIR="${HOME}/.kimi"
BACKUP_DIR="${HOME}/.kimi.backup.$(date +%Y%m%d_%H%M%S)"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Kimi Workflow — Instalador Automático                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo

# ─── 1. VERIFICAR KIMI INSTALADO ─────────────────────────────────────────────
if ! command -v kimi >/dev/null 2>&1; then
    echo "⚠️  Kimi Code CLI no encontrado en PATH."
    echo "   Instálalo primero desde: https://kimi.com/coding"
    exit 1
fi

echo "✅ Kimi Code CLI detectado: $(kimi --version 2>/dev/null || echo 'version unknown')"

# ─── 2. BACKUP DE CONFIGURACIÓN EXISTENTE ────────────────────────────────────
if [ -d "$KIMI_DIR" ]; then
    echo "📦 Creando backup en: $BACKUP_DIR"
    cp -r "$KIMI_DIR" "$BACKUP_DIR"
    echo "✅ Backup completado"
else
    echo "📁 Creando directorio ~/.kimi/"
    mkdir -p "$KIMI_DIR"
fi

echo

# ─── 3. COPIAR ARCHIVOS PRINCIPALES ──────────────────────────────────────────
echo "📝 Instalando configuración principal..."
cp "$REPO_DIR/config.toml" "$KIMI_DIR/config.toml"
cp "$REPO_DIR/AGENTS.md" "$KIMI_DIR/AGENTS.md"
echo "   ✅ config.toml"
echo "   ✅ AGENTS.md"

# ─── 4. INSTALAR SKILLS ──────────────────────────────────────────────────────
echo "🧠 Instalando skills..."
mkdir -p "$KIMI_DIR/skills"
for skill_dir in "$REPO_DIR"/skills/*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$KIMI_DIR/skills/$skill_name"
    cp "$skill_dir"SKILL.md "$KIMI_DIR/skills/$skill_name/SKILL.md"
    echo "   ✅ $skill_name"
done

# ─── 5. INSTALAR HOOKS ───────────────────────────────────────────────────────
echo "🪝 Instalando hooks..."
mkdir -p "$KIMI_DIR/hooks"
for hook in "$REPO_DIR"/hooks/*.sh; do
    hook_name=$(basename "$hook")
    cp "$hook" "$KIMI_DIR/hooks/$hook_name"
    chmod +x "$KIMI_DIR/hooks/$hook_name"
    echo "   ✅ $hook_name"
done

# ─── 6. CREAR DIRECTORIOS DE SOPORTE ─────────────────────────────────────────
echo "📂 Creando directorios de soporte..."
mkdir -p "$KIMI_DIR"/{logs,sessions,plans,credentials,telemetry,user-history}
echo "   ✅ Directorios creados"

# ─── 7. AJUSTES DE PERMISOS ──────────────────────────────────────────────────
echo "🔐 Ajustando permisos..."
chmod 700 "$KIMI_DIR"
chmod 600 "$KIMI_DIR/config.toml" 2>/dev/null || true
echo "   ✅ Permisos ajustados"

# ─── 8. VERIFICACIÓN ─────────────────────────────────────────────────────────
echo
echo "🔍 Verificando instalación..."

errors=0

# Verificar config.toml
if [ -f "$KIMI_DIR/config.toml" ]; then
    echo "   ✅ config.toml presente"
else
    echo "   ❌ config.toml NO encontrado"
    errors=$((errors + 1))
fi

# Verificar AGENTS.md
if [ -f "$KIMI_DIR/AGENTS.md" ]; then
    echo "   ✅ AGENTS.md presente"
else
    echo "   ❌ AGENTS.md NO encontrado"
    errors=$((errors + 1))
fi

# Verificar skills
for skill in project-flow scope-guard subagent-orchestrator; do
    if [ -f "$KIMI_DIR/skills/$skill/SKILL.md" ]; then
        echo "   ✅ Skill '$skill' presente"
    else
        echo "   ❌ Skill '$skill' NO encontrado"
        errors=$((errors + 1))
    fi
done

# Verificar hooks
for hook in auto-format.sh auto-init-project.sh protect-sensitive.sh save-project-memory.sh; do
    if [ -x "$KIMI_DIR/hooks/$hook" ]; then
        echo "   ✅ Hook '$hook' presente y ejecutable"
    else
        echo "   ❌ Hook '$hook' NO encontrado o no ejecutable"
        errors=$((errors + 1))
    fi
done

# ─── 9. RESUMEN ──────────────────────────────────────────────────────────────
echo
echo "╔══════════════════════════════════════════════════════════════╗"
if [ "$errors" -eq 0 ]; then
    echo "║              ✅ INSTALACIÓN COMPLETADA                       ║"
else
    echo "║              ⚠️  INSTALACIÓN CON $errors ERRORES              ║"
fi
echo "╚══════════════════════════════════════════════════════════════╝"
echo
echo "📋 Resumen:"
echo "   • Directorio Kimi: $KIMI_DIR"
echo "   • Backup anterior: $BACKUP_DIR"
echo "   • Repo fuente:     $REPO_DIR"
echo
echo "🚀 Próximos pasos:"
echo "   1. Abre una nueva terminal"
echo "   2. Ve a cualquier directorio de proyecto"
echo "   3. Ejecuta: kimi"
echo "   4. Prueba: 'inicia proyecto' o '/flow:project-flow'"
echo
echo "📖 Para más detalles: cat $REPO_DIR/INSTALL.md"
echo

exit "$errors"
