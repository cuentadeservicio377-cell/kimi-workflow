# Guía de Instalación — Kimi Workflow

> Instalación completa del sistema de memoria persistente para agentes IA.

---

## Pre-requisitos

- macOS Sonoma+ (testeado)
- Homebrew instalado
- Git configurado (`user.name` y `user.email`)

---

## Paso 1: Clonar el Repo

```bash
cd ~
git clone https://github.com/cuentadeservicio377-cell/kimi-workflow.git
cd kimi-workflow
```

---

## Paso 2: Ejecutar Instalador Automático

```bash
chmod +x install.sh
./install.sh
```

Esto crea:
- `~/.kimi/config.toml`
- `~/.kimi/hooks/` (3 hooks)
- `~/.kimi/skills/` (9 skills)
- `~/.config/kimi/mcp.json`
- `~/Documents/Kimi Code/.gbrain/` (directorio vacío)
- `~/Documents/Kimi Code/.brain/` (directorio vacío)

---

## Paso 3: Instalar Ollama

```bash
brew install ollama
```

### Iniciar Ollama

```bash
# Terminal 1 — dejar corriendo
ollama serve

# Terminal 2 — descargar modelo
curl -X POST http://localhost:11434/api/pull -d '{"name": "nomic-embed-text"}'
```

Verificar:
```bash
curl http://localhost:11434/api/tags | jq '.models[].name'
# Debe mostrar "nomic-embed-text:latest"
```

---

## Paso 4: Instalar gbrain

```bash
# Con Bun (recomendado — más rápido)
bun install -g gbrain

# O con npm
npm install -g gbrain
```

---

## Paso 5: Inicializar gbrain

**⚠️ CRÍTICO**: El orden importa. `gbrain init` crea el schema con las dimensiones correctas.

```bash
export GB_CONFIG_PATH="$HOME/Documents/Kimi Code/.gbrain/config.json"

# Crear directorio
mkdir -p "$HOME/Documents/Kimi Code/.gbrain"

# Inicializar con las dimensiones correctas
gbrain init --pglite \
  --embedding-model ollama:nomic-embed-text \
  --embedding-dimensions 768

# Copiar config con base_urls
cp gbrain-config.json "$GB_CONFIG_PATH"
```

### Verificar Configuración

```bash
cat "$GB_CONFIG_PATH"
```

Debe mostrar:
```json
{
  "engine": "pglite",
  "database_path": "~/Documents/Kimi Code/.gbrain/brain.pglite",
  "embedding_model": "ollama:nomic-embed-text",
  "embedding_dimensions": 768,
  "base_urls": {
    "ollama": "http://localhost:11434/v1"
  }
}
```

**Nota**: Reemplazar `~` con el path absoluto a tu home (ej: `/Users/tuusuario/`).

---

## Paso 6: Verificar Todo

### gbrain health

```bash
gbrain doctor --json
```

Esperado:
```json
{
  "status": "healthy",
  "embedding": {
    "provider": "ollama",
    "model": "nomic-embed-text",
    "dimensions": 768,
    "status": "connected"
  },
  "database": {
    "engine": "pglite",
    "path": ".../brain.pglite",
    "status": "connected"
  }
}
```

### Test de embedding

```bash
echo "Test de embeddings" | gbrain put test/page1
```

Debe completarse sin errores.

---

## Paso 7: Importar Proyectos Existentes (Opcional)

Si tienes proyectos existentes que quieres indexar:

```bash
cd ~/Documents/Kimi\ Code/
gbrain import mi-proyecto --source mi-proyecto
```

---

## Paso 8: Probar Flujo Completo

### Crear un proyecto de prueba

```bash
cd ~/Documents/Kimi\ Code/
mkdir proyecto-test && cd proyecto-test
```

### Iniciar Kimi

```bash
kimi
```

### Verificar auto-inicialización

El hook `auto-init-project.sh` debería haber creado:
- `.git/`
- `README.md`, `TODOS.md`, `.gitignore`
- `.kimi/memory/MEMORY.md`, `PLAN.md`, `PROGRESS.md`
- `.kimi/AGENTS.md`

Verificar:
```bash
ls -la
ls -la .kimi/memory/
cat .kimi/memory/MEMORY.md
```

### Cerrar sesión

Salir de Kimi (`/exit` o Ctrl+D). El hook `save-project-memory.sh` debería:
1. Hacer auto-commit
2. Actualizar MEMORY.md
3. Snapshot a gbrain (async)

Verificar:
```bash
git log --oneline -3
```

Debe mostrar un commit con mensaje tipo:
```
session(proyecto-test): sincronización 2026-05-23 18:30
```

---

## Troubleshooting

### "gbrain: command not found"

```bash
which gbrain
# Si no muestra nada, agregar al PATH:
export PATH="$PATH:$HOME/.bun/bin"
# O si usaste npm:
export PATH="$PATH:$HOME/.npm/bin"
```

### "ollama: command not found"

```bash
brew services start ollama
# O:
ollama serve &
```

### "dim mismatch" o "embedding failed"

1. Verificar que `config.json` tiene `base_urls.ollama`
2. Verificar que Ollama está corriendo
3. Si todo está bien pero sigue fallando, reinicializar:
   ```bash
   rm ~/Documents/Kimi\ Code/.gbrain/brain.pglite
   gbrain init --pglite --embedding-model ollama:nomic-embed-text --embedding-dimensions 768
   cp gbrain-config.json ~/Documents/Kimi\ Code/.gbrain/config.json
   ```

### Hooks no se ejecutan

1. Verificar permisos:
   ```bash
   ls -la ~/.kimi/hooks/
   chmod +x ~/.kimi/hooks/*.sh
   ```
2. Verificar que `config.toml` tiene la sección `[[hooks]]`
3. Verificar que el path del comando es correcto (usa `~` o path absoluto)

### "fatal: not a git repository"

El hook `auto-init-project.sh` debería inicializar git automáticamente. Si no lo hizo:
```bash
git init -b main
```

---

## Actualización

Para actualizar el sistema:

```bash
cd ~/kimi-workflow
git pull
./install.sh
```

El instalador sobreescribirá config, hooks y skills con las últimas versiones.

---

> **Listo** — Tu sistema Kimi Workflow está instalado y funcionando.
