# Kimi Workflow — Configuración Portátil

> Repositorio privado con la configuración completa de Kimi Code CLI para desarrollo de software profesional.

## ¿Qué incluye?

| Componente | Descripción |
|------------|-------------|
| `AGENTS.md` | Reglas globales del agente: flujo de trabajo, seguridad, calidad |
| `config.toml` | Configuración optimizada para proyectos grandes (100+ tareas) |
| `skills/` | Skills personalizadas: `project-flow`, `scope-guard`, `subagent-orchestrator` |
| `hooks/` | 4 hooks de automatización: init, save, format, protect |
| `INSTALL.md` | Guía paso a paso para instalar en cualquier máquina |

## Instalación Rápida

```bash
# 1. Clonar en la nueva computadora
git clone https://github.com/cuentadeservicio377-cell/kimi-workflow.git ~/.kimi-workflow

# 2. Ejecutar el instalador
cd ~/.kimi-workflow && bash install.sh
```

Ver [`INSTALL.md`](INSTALL.md) para instrucciones detalladas.

## Flujo de Trabajo

Este workflow implementa un sistema completo de gestión de proyectos:

```
ONBOARDING → PLAN → EJECUCIÓN POR FASES → SHIP
```

### Comandos clave

| Comando | Acción |
|---------|--------|
| `inicia proyecto` / `/flow:project-flow` | Inicia flujo completo |
| `continúa` / `sigue` / `resume` | Retoma desde último checkpoint |
| `scope check` | Verifica si estamos en scope |
| `parking lot` | Muestra todo lo pospuesto |
| `back to plan` | Vuelve al plan maestro |

## Seguridad

Este repo **NO incluye**:
- Credenciales de API (`credentials/`, `kimi.json` con tokens)
- Historial de sesiones (`sessions/`)
- Logs (`logs/`)
- Device ID único (`device_id`)

Al instalar en una nueva máquina, el agente Kimi te guiará para autenticarte con tu propia cuenta.

## Stack Soportado

- **Modelo:** `kimi-code/kimi-for-coding` (Kimi k2.6)
- **Lenguajes:** TypeScript, Python, Go, JavaScript, y más
- **Frameworks:** React, Next.js, NestJS, Node.js
- **Infra:** Railway, GitHub Actions, Docker

## Licencia

Uso personal exclusivo.
