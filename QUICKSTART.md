# QUICKSTART — Para Otro Agente Kimi

> Si te dan este repo y te dicen "instálalo", sigue estos pasos.

## 1. Clonar e Instalar (2 minutos)

```bash
cd ~
git clone https://github.com/cuentadeservicio377-cell/kimi-workflow.git
cd kimi-workflow
chmod +x install.sh
./install.sh
```

## 2. Instalar Ollama (1 minuto)

```bash
brew install ollama
ollama pull nomic-embed-text
# En otra terminal:
ollama serve
```

## 3. Instalar gbrain (1 minuto)

```bash
bun install -g gbrain   # o npm install -g gbrain
```

## 4. Inicializar gbrain (30 segundos)

```bash
export GB_CONFIG_PATH="$HOME/Documents/Kimi Code/.gbrain/config.json"
gbrain init --pglite \
  --embedding-model ollama:nomic-embed-text \
  --embedding-dimensions 768
cp gbrain-config.json "$GB_CONFIG_PATH"
```

## 5. Verificar (10 segundos)

```bash
gbrain doctor --json   # debe mostrar health ≥ 80, dim=768
curl http://localhost:11434/api/tags   # debe mostrar nomic-embed-text
```

## 6. Probar Flujo (1 minuto)

```bash
cd ~/Documents/Kimi\ Code/
mkdir test-proyecto && cd test-proyecto
# Iniciar Kimi aquí — los hooks auto-crearán la estructura
```

## Listo. El sistema está funcionando.

---

## Estructura Creada por install.sh

```
~/.kimi/
├── config.toml          # Config Kimi CLI
├── hooks/
│   ├── auto-init-project.sh
│   ├── save-project-memory.sh
│   ├── protect-sensitive.sh
│   └── auto-format.sh
└── skills/
    ├── braindump-init/
    ├── project-flow/
    ├── scope-guard/
    ├── subagent-orchestrator/
    ├── project-closer/
    ├── gbrain-local/
    ├── systematic-debugging/
    ├── test-driven-development/
    └── verification-before-completion/

~/.config/kimi/
└── mcp.json             # Registro MCP gbrain

~/Documents/Kimi Code/
├── .brain/
│   └── MEMORY.md        # Índice maestro
└── .gbrain/
    ├── config.json      # Config embeddings
    └── brain.pglite     # DB PGLite (se crea con gbrain init)
```

## Archivos Clave del Repo

| Archivo | Propósito |
|---------|-----------|
| `README.md` | Documentación completa (léelo primero) |
| `INSTALL.md` | Guía paso a paso detallada |
| `AGENTS.md` | Reglas de oro del sistema |
| `config.toml` | Configuración Kimi CLI |
| `mcp.json` | Configuración MCP servers |
| `gbrain-config.json` | Template config gbrain |
| `install.sh` | Instalador automático |
| `hooks/` | Scripts de automatización |
| `skills/` | 9 skills personalizados |
| `templates/` | Templates para nuevos proyectos |

## Decisiones Arquitectónicas Clave

1. **max_ralph_iterations = 3** — previene loops infinitos de auto-iteración
2. **keep_alive_on_exit = false** — mata tasks fantasmas al cerrar
3. **Ollama + nomic-embed-text** — embeddings 100% offline, 768d
4. **gbrain + PGLite** — búsqueda semántica local sin APIs externas
5. **Hooks SessionStart/End** — auto-init proyectos + auto-commit + snapshot memoria
6. **Brain Central** — índice maestro de todos los proyectos

## Troubleshooting Rápido

| Problema | Solución |
|----------|----------|
| gbrain no encuentra Ollama | Verificar `ollama serve` corriendo y `config.json` tiene `base_urls.ollama` |
| dim mismatch | `rm brain.pglite && gbrain init --pglite --embedding-model ollama:nomic-embed-text --embedding-dimensions 768` |
| Hooks no ejecutan | `chmod +x ~/.kimi/hooks/*.sh` |
| Commits fallan | `git config --global user.name/email` |
| Kimi no lee config | Verificar `~/.kimi/config.toml` existe y es válido TOML |

## Estado del Sistema (última vez)

- 8 proyectos activos
- gbrain health: 80/100, 92% coverage (349/382 chunks)
- 9 skills instalados
- 4 hooks activos
- Embedding: Ollama nomic-embed-text (768d)
