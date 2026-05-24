# GBrain Local — Memoria Persistente para Kimi

## Trigger

Cualquier proyecto en `/Users/pablomeneses/Documents/Kimi Code/`

## Estado

- **MCP Server**: `gbrain` configurado en `~/.config/kimi/mcp.json`
- **Base de datos**: `/Users/pablomeneses/Documents/Kimi Code/.gbrain` (PGLite)
- **Comandos disponibles vía MCP**:
  - `get_page` — Leer página por slug
  - `put_page` — Escribir/actualizar página
  - `delete_page` — Eliminar página
  - `list_pages` — Listar páginas
  - `search_pages` — Búsqueda híbrida
  - `query_pages` — Query semántico
  - `graph_query` — Búsqueda en grafo

## Flujo de Memoria

### Al INICIO de cada sesión:
1. Leer `/Users/pablomeneses/Documents/Kimi Code/.brain/MEMORY.md`
2. Leer `.kimi/memory/MEMORY.md` del proyecto actual
3. Leer `TODOS.md` del proyecto actual
4. **Opcional**: Usar MCP `search_pages` para buscar contexto del proyecto en gbrain
5. Resumir estado en máximo 5 líneas

### Al FINAL de cada sesión:
1. Actualizar `.kimi/memory/PROGRESS.md` con lo hecho
2. Actualizar `TODOS.md` marcando tareas completadas
3. Si hay decisiones arquitectónicas nuevas:
   - Escribir en `.kimi/memory/MEMORY.md`
   - **Guardar en gbrain** con `put_page` (slug: `<proyecto>/memory`)
4. Hacer commit con mensaje descriptivo
5. Actualizar brain central `.brain/MEMORY.md`

## Regla de ORO: Cierre Completo

Antes de terminar CUALQUIER sesión:
- [ ] ¿El código funciona? (correr tests/verificar)
- [ ] ¿Está documentado?
- [ ] ¿Hay commit?
- [ ] ¿TODOS.md está actualizado?
- [ ] ¿MEMORY.md refleja cambios?
- [ ] ¿gbrain tiene la última versión? (`put_page` si hay cambios)

Si falta algo, NO terminar la sesión. Arreglar antes.

## Uso de MCP (ejemplos)

```
# Guardar memoria de proyecto en gbrain
-> gbrain.put_page
   slug: "hermes-business-os/memory"
   content: "# Memoria Hermes\n\nÚltimo cambio: ..."

# Buscar contexto
-> gbrain.search_pages
   query: "arquitectura dashboard"
   limit: 5

# Recuperar página específica
-> gbrain.get_page
   slug: "hermes-business-os/docs/architecture"
```
