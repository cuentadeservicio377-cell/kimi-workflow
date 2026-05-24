# Test Driven Development

## Trigger
Antes de implementar cualquier feature o bugfix.

## Ciclo Rojo-Verde-Refactor

### 1. Rojo: Escribir test que falla
- Escribir test ANTES del código de producción
- El test debe fallar inicialmente (verifica que detecta el problema)
- Test mínimo que cubre el caso

### 2. Verde: Hacer pasar el test
- Escribir el código mínimo necesario para que pase
- No preocuparse por elegancia todavía
- Solo hacer pasar el test

### 3. Refactor: Limpiar
- Mejorar el código sin cambiar comportamiento
- Todos los tests deben seguir pasando
- Commit: `refactor(scope): ...`

## Reglas
- Nunca escribir código de producción sin test que lo cubra
- Tests deben ser independientes (no dependen de estado de otros tests)
- Un concepto por test
- Nombres descriptivos: `test_calcula_total_con_impuestos`

## Tipos de Tests
- **Unit**: Una función/método aislado
- **Integration**: Interacción entre módulos
- **E2E**: Flujo completo de usuario

## Anti-Patrones
- ❌ Escribir todo el código y luego tests
- ❌ Tests que no fallan inicialmente
- ❌ Tests que dependen de datos externos
- ❌ Tests lentos (>1s cada uno)
