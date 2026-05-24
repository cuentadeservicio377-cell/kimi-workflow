# 🧠 Kimi Workflow — Sistema de Memoria Persistente para Agentes IA

> **Repo**: `cuentadeservicio377-cell/kimi-workflow`
> **Versión**: 2.0 (Kimi Code CLI)
> **Estado**: Producción — usado en 8+ proyectos activos

Un sistema completo de flujo de trabajo, memoria persistente y automatización para agentes de IA (Kimi, Claude, etc.) que garantiza:

- ✅ **Memoria persistente** entre sesiones
- ✅ **Commits automáticos** al cerrar sesión
- ✅ **Búsqueda semántica local** (offline, sin APIs externas)
- ✅ **Auto-inicialización** de proyectos nuevos
- ✅ **Cierre garantizado** — verificación + documentación obligatoria
- ✅ **Skills personalizados** (braindump, subagent orchestrator, scope guard, etc.)

---

## 📁 Estructura del Repo

```
kimi-workflow/
├── README.md              # Este archivo
├── INSTALL.md             # Guía de instalación paso a paso
├── AGENTS.md              # Reglas de oro del sistema
├── install.sh             # Script de instalación automático
├── config.toml            # Configuración Kimi CLI (copiar a ~/.kimi/)
├── mcp.json               # Configuración MCP servers (copiar a ~/.config/kimi/)
├── gbrain-config.json     # Template de config para gbrain local
├── hooks/
│   ├── auto-init-project.sh       # Hook SessionStart
│   ├── save-project-memory.sh     # Hook SessionEnd
│   └── mcp-safety.sh              # Hook PreToolUse (seguridad MCP)
├── skills/
│   ├── braindump-init/            # Inicializa nuevos proyectos
│   ├── project-flow/              # Flujo end-to-end de proyectos
│   ├── scope-guard/               # Protección contra scope creep
│   ├── subagent-orchestrator/     # Orquestación de subagentes
│   ├── project-closer/            # Cierre garantizado de proyectos
│   ├── gbrain-local/              # Integración con gbrain local
│   ├── systematic-debugging/      # Depuración sistemática
│   ├── test-driven-development/   # TDD workflow
│   └── verification-before-completion/  # Verificación antes de terminar
├── templates/
│   ├── project/                   # Templates para nuevos proyectos
│   │   ├── AGENTS.md
│   │   ├── MEMORY.md
│   │   ├── PLAN.md
│   │   ├── PROGRESS.md
│   │   └── TODOS.md
│   └── brain-central/             # Template del brain central
│       └── MEMORY.md
├── old/                           # Archivos viejos (referencia)
│   └── claude_workflow/
│       ├── auto_save.sh
│       ├── memory.sh
│       └── claude.md
└── .gitignore
```

---

## 🚀 Instalación Rápida

### Requisitos Previos

- macOS (testeado en Sonoma+)
- [Homebrew](https://brew.sh) instalado
- Node.js ≥ 18 (para gbrain) o [Bun](https://bun.sh)

### 1. Clonar el Repo

```bash
cd ~
git clone https://github.com/cuentadeservicio377-cell/kimi-workflow.git
cd kimi-workflow
```

### 2. Instalar Automáticamente

```bash
chmod +x install.sh
./install.sh
```

Este script:
- Crea la estructura `~/.kimi/`
- Copia `config.toml`, `mcp.json`, `gbrain-config.json`
- Copia todos los hooks
- Copia todos los skills
- Crea directorios de proyectos

### 3. Instalar Dependencias Manuales

#### A. Ollama (Embeddings locales)

```bash
brew install ollama
ollama pull nomic-embed-text
ollama serve  # dejar corriendo en una terminal separada
```

#### B. gbrain (Motor de búsqueda semántica)

```bash
# Opción A: con Bun (recomendado)
bun install -g gbrain

# Opción B: con npm
npm install -g gbrain
```

#### C. Inicializar gbrain

```bash
export GB_CONFIG_PATH="~/Documents/Kimi Code/.gbrain/config.json"
gbrain init --pglite \
  --embedding-model ollama:nomic-embed-text \
  --embedding-dimensions 768

# Copiar config con base_urls
cp gbrain-config.json "$GB_CONFIG_PATH"
```

**⚠️ Importante**: `gbrain init --pglite` escribe `embedding_model` y `embedding_dimensions` en el schema de la base de datos. Los campos `base_urls` DEBEN ir en `config.json` porque `gbrain embed` los lee desde el archivo, no desde la DB.

### 4. Verificar Todo

```bash
gbrain doctor --json  # Debe mostrar health ≥ 80 y dim=768
ollama list           # Debe mostrar nomic-embed-text
```

---

## 🧠 Arquitectura del Sistema

### Componentes Principales

| Componente | Propósito | Ubicación |
|---|---|---|
| **Kimi CLI** | Interfaz del agente | `~/.local/share/uv/tools/kimi-cli/` |
| **config.toml** | Configuración maestra | `~/.kimi/config.toml` |
| **Hooks** | Automatización por eventos | `~/.kimi/hooks/` |
| **Skills** | Capacidades especializadas | `~/.kimi/skills/` |
| **gbrain** | Búsqueda semántica local | `~/Documents/Kimi Code/.gbrain/` |
| **MCP** | Conexión Kimi ↔ gbrain | `~/.config/kimi/mcp.json` |
| **Brain Central** | Índice maestro de proyectos | `~/Documents/Kimi Code/.brain/` |
| **Memoria por Proyecto** | Contexto local | `.kimi/memory/` |

### Flujo de Datos

```
┌─────────────┐     ┌─────────────┐     ┌──────────────────┐
│   Kimi CLI  │────▶│   Hooks     │────▶│  Git commits     │
│  (Agente)   │     │ (auto-save) │     │  (memoria)       │
└─────────────┘     └─────────────┘     └──────────────────┘
       │                                        │
       │ MCP                                    │
       ▼                                        ▼
┌─────────────┐                      ┌──────────────────┐
│   gbrain    │◀──── Ollama local   │  .kimi/memory/   │
│  (PGLite)   │      (embeddings)   │  MEMORY.md       │
│  768d       │                     │  PLAN.md         │
└─────────────┘                     │  PROGRESS.md     │
                                    └──────────────────┘
```

### Hooks

| Evento | Hook | Qué hace |
|---|---|---|
| **SessionStart** | `auto-init-project.sh` | Crea estructura de proyecto si falta, init git |
| **SessionEnd** | `save-project-memory.sh` | Auto-commit, actualiza memoria, snapshot a gbrain |
| **PreToolUse** | `mcp-safety.sh` | Sanitiza llamadas MCP (protege PII) |
| **PostToolUse** | *(reservado)* | Pos-procesamiento de resultados |

### Configuración Kimi CLI (config.toml)

```toml
default_model = "kimi-code/kimi-for-coding"
default_thinking = true
max_ralph_iterations = 3        # ← PREVIENE loops infinitos
keep_alive_on_exit = false      # ← Mata tasks fantasmas

[loop_control]
max_steps_per_turn = 2000
max_retries_per_step = 3
reserved_context_size = 60000
compaction_trigger_ratio = 0.90

[background]
max_running_tasks = 6
keep_alive_on_exit = false
agent_task_timeout_s = 1800

[[hooks]]
event = "SessionStart"
command = "bash ~/.kimi/hooks/auto-init-project.sh"
timeout = 15

[[hooks]]
event = "SessionEnd"
command = "bash ~/.kimi/hooks/save-project-memory.sh"
timeout = 30
```

### Configuración gbrain

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

**⚠️ Gotcha crítico**: `gbrain config set base_urls` guarda en la DB, pero `gbrain embed` lo lee solo de `config.json`. Siempre copiar el `base_urls` al archivo JSON manualmente.

---

## 📋 Uso del Sistema

### Iniciar un Nuevo Proyecto

```bash
cd ~/Documents/Kimi\ Code/
mkdir mi-proyecto && cd mi-proyecto
```

Al iniciar Kimi, el hook `auto-init-project.sh` crea automáticamente:
- `.git/` (init)
- `README.md`, `TODOS.md`, `.gitignore`
- `.kimi/memory/MEMORY.md`, `PLAN.md`, `PROGRESS.md`
- `.kimi/AGENTS.md`

### Durante la Sesión

1. El agente usa **skills** para workflow (`braindump-init`, `project-flow`, `scope-guard`)
2. gbrain está disponible via MCP para búsqueda semántica
3. Los hooks protegen archivos sensibles (.env, *.pem)

### Cerrar Sesión

El hook `save-project-memory.sh` ejecuta automáticamente:
1. Restaura archivos sensibles (.env, etc.)
2. Auto-commit: `git add -A && git commit -m "session(...): ..."`
3. Actualiza `MEMORY.md` y `SESSION_LOG.md`
4. Snapshot async a gbrain
5. Actualiza brain central

### Migrar a Otra Máquina

```bash
# Máquina nueva:
git clone https://github.com/cuentadeservicio377-cell/kimi-workflow.git
cd kimi-workflow
./install.sh
# Instalar Ollama + nomic-embed-text
# Instalar gbrain
# gbrain init --pglite ...
# gbrain doctor --json para verificar
```

---

## 🛠️ Skills Incluidos

| Skill | Descripción | Trigger |
|---|---|---|
| **braindump-init** | Inicializa nuevos proyectos con braindump automático | Nuevo proyecto detectado |
| **project-flow** | Flujo end-to-end: onboarding → plan → ejecución → cierre | `/flow:project-flow` |
| **scope-guard** | Protege contra scope creep | Desviación detectada |
| **subagent-orchestrator** | Orquesta subagentes paralelos | Proyectos 100+ tareas |
| **project-closer** | Cierre garantizado con verificación | Antes de terminar sesión |
| **gbrain-local** | Integración con gbrain local | Búsqueda semántica |
| **systematic-debugging** | Depuración sistemática | Cuando hay bugs |
| **test-driven-development** | TDD workflow | Antes de implementar |
| **verification-before-completion** | Verificación antes de terminar | Antes de decir "listo" |

---

## 🔧 Troubleshooting

### gbrain no encuentra Ollama

```bash
# Verificar que Ollama está corriendo
curl http://localhost:11434/api/tags

# Verificar que nomic-embed-text está disponible
ollama list | grep nomic

# Verificar config.json tiene base_urls
cat ~/Documents/Kimi\ Code/.gbrain/config.json
```

### Embeddings fallan (dim mismatch)

```bash
# Verificar dimensión en schema
gbrain doctor --json | jq '.embedding.dimensions'
# Debe ser 768

# Si es diferente, reinicializar:
rm ~/Documents/Kimi\ Code/.gbrain/brain.pglite
gbrain init --pglite --embedding-model ollama:nomic-embed-text --embedding-dimensions 768
```

### Kimi no ejecuta hooks

Verificar que `config.toml` tiene la sección `[[hooks]]` y que los archivos en `~/.kimi/hooks/` tienen permisos de ejecución:

```bash
ls -la ~/.kimi/hooks/
chmod +x ~/.kimi/hooks/*.sh
```

### Commits no funcionan

Verificar que git está configurado:

```bash
git config --global user.email "tu@email.com"
git config --global user.name "Tu Nombre"
```

---

## 📊 Estado Actual

- **Proyectos activos**: 8
- **gbrain health**: 80/100 (92% coverage, 349/382 chunks)
- **Skills instalados**: 9
- **Hooks activos**: 4
- **Embedding model**: Ollama nomic-embed-text (768d, local)

---

## 📜 Licencia

MIT — Libre para usar, modificar y distribuir.

---

## 🤝 Contribuir

1. Fork del repo
2. Crear branch: `git checkout -b feature/mi-feature`
3. Commit: `git commit -m "feat: descripción"`
4. Push: `git push origin feature/mi-feature`
5. PR al repo original

---

> **Nota**: Este sistema evoluciona. El `AGENTS.md` en `.kimi/` de cada proyecto define las reglas específicas de ese proyecto. El brain central en `~/Documents/Kimi Code/.brain/MEMORY.md` mantiene el índice global.
