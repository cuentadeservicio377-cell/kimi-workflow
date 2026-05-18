# Guía de Instalación — Kimi Workflow

> Instala este flujo de trabajo en cualquier computadora con Kimi Code CLI.

## Requisitos Previos

1. **Kimi Code CLI** instalado en la nueva máquina
   ```bash
   # Si no lo tienes, instálalo siguiendo la documentación oficial de Kimi
   ```

2. **Git** configurado con acceso a este repositorio privado

3. **Python 3** (para que los hooks funcionen correctamente)

4. **Prettier** (opcional, para formateo automático de JS/TS)
   ```bash
   npm install -g prettier
   ```

## Instalación Automática (Recomendado)

```bash
# 1. Clonar este repo
git clone https://github.com/cuentadeservicio377-cell/kimi-workflow.git ~/.kimi-workflow

# 2. Ejecutar el instalador
cd ~/.kimi-workflow && bash install.sh

# 3. Verificar instalación
kimi --version
```

El script `install.sh` hará:
- ✅ Copiar `config.toml` a `~/.kimi/`
- ✅ Copiar `AGENTS.md` a `~/.kimi/`
- ✅ Copiar skills a `~/.kimi/skills/`
- ✅ Copiar hooks a `~/.kimi/hooks/` y hacerlos ejecutables
- ✅ Crear directorios necesarios (`logs`, `sessions`, etc.)
- ✅ Hacer backup de configuración anterior si existe

## Instalación Manual

Si prefieres control total:

### Paso 1: Backup
```bash
cp -r ~/.kimi ~/.kimi.backup.$(date +%Y%m%d_%H%M%S)
```

### Paso 2: Copiar archivos
```bash
# Configuración principal
cp config.toml ~/.kimi/
cp AGENTS.md ~/.kimi/

# Skills
mkdir -p ~/.kimi/skills
cp -r skills/* ~/.kimi/skills/

# Hooks
mkdir -p ~/.kimi/hooks
cp -r hooks/* ~/.kimi/hooks/
chmod +x ~/.kimi/hooks/*.sh
```

### Paso 3: Directorios de soporte
```bash
mkdir -p ~/.kimi/{logs,sessions,plans,credentials,telemetry,user-history}
```

### Paso 4: Autenticación
```bash
# Inicia sesión en Kimi Code CLI
kimi login
# O sigue el flujo de autenticación que aparezca
```

## Verificación

Después de instalar, abre una nueva sesión de Kimi en cualquier directorio de proyecto y verifica:

1. **Hooks funcionando**: Deberías ver `[kimi-hook] Git inicializado` si entras a un directorio sin git
2. **Skills disponibles**: Prueba `/flow:project-flow` o di `"inicia proyecto"`
3. **Formateo automático**: Crea un archivo `.js` y guarda — debería formatearse solo

## Primer Uso

```bash
# Ve a cualquier directorio de proyecto
cd ~/mi-proyecto

# Inicia Kimi
kimi

# Dentro de Kimi, prueba:
> inicia proyecto
# Debería activar el flujo completo: onboarding → plan → ejecución
```

## Actualización

Cuando haya cambios en este repo:

```bash
cd ~/.kimi-workflow
git pull
bash install.sh
```

## Solución de Problemas

### Los hooks no se ejecutan
```bash
chmod +x ~/.kimi/hooks/*.sh
```

### Skills no aparecen
```bash
# Reinicia Kimi o recarga configuración
kimi --reload-skills
```

### Error de autenticación
```bash
# Reautentica
kimi auth login
```

### Conflictos con config anterior
```bash
# Restaura backup
rm -rf ~/.kimi
cp -r ~/.kimi.backup.XXXX ~/.kimi
```

## Estructura Final

Tu `~/.kimi/` debería verse así:

```
~/.kimi/
├── AGENTS.md           ← Reglas globales
├── config.toml         ← Configuración
├── skills/
│   ├── project-flow/
│   ├── scope-guard/
│   └── subagent-orchestrator/
├── hooks/
│   ├── auto-format.sh
│   ├── auto-init-project.sh
│   ├── protect-sensitive.sh
│   └── save-project-memory.sh
├── logs/
├── sessions/
├── plans/
└── ... (creado por Kimi)
```

## Soporte

Si algo falla, el agente Kimi en la nueva máquina puede ayudarte a debuggear. Solo di:

```
> help me install this workflow
```

O revisa los logs:
```bash
cat ~/.kimi/logs/latest.log
```
