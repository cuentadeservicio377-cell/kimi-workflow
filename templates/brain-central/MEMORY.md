# Kimi Brain Central — Memoria Persistente

> Última actualización: {DATE}
> Este archivo es el cerebro central de todos los proyectos Kimi.

## Proyectos Activos

### {PROYECTO_1}
- **Estado**: En progreso
- **Stack**: Por confirmar
- **Repo**: Git inicializado
- **Memoria**: `.kimi/memory/` con MEMORY.md, PLAN.md, PROGRESS.md

## Reglas de Cierre de Proyectos (OBLIGATORIO)

1. **Siempre verificar que funcione** antes de terminar
2. **Siempre correr tests** si existen
3. **Siempre documentar** cambios en CHANGELOG o README
4. **Siempre actualizar TODOS.md** marcando tareas completadas
5. **Siempre hacer commit** con mensaje descriptivo
6. **Nunca dejar código roto** — arreglar antes de terminar sesión

## Infraestructura Configurada

- **gbrain**: Instalado en `~/Documents/Kimi Code/.gbrain` (PGLite)
  - Motor: PGLite (Postgres local)
  - Health: por verificar
  - Embeddings: Ollama nomic-embed-text (local, 768d)
- **MCP**: Configurado en `~/.config/kimi/mcp.json`
- **Skills**: Disponibles en `~/.kimi/skills/`
- **AGENTS.md**: Actualizado con protocolo de cierre obligatorio

## Decisiones Arquitectónicas Globales

- Todos los proyectos en `~/Documents/Kimi Code/`
- Cada proyecto DEBE tener: README, TODOS, .git, `.kimi/memory/`
- Brain central como índice maestro
- gbrain como motor de búsqueda semántica local

## Técnicas y Patrones Aprendidos

_Pendiente — se actualiza con cada proyecto_

## Próximos Pasos Sugeridos

1. Completar braindumps de proyectos activos
2. Importar proyectos a gbrain
3. Definir stacks técnicos pendientes
