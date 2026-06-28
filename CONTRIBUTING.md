# Guía de Contribución

Gracias por tu interés en mejorar este material. Este repositorio es
un recurso académico abierto — las contribuciones de estudiantes,
egresados y colegas docentes son bienvenidas.

## Tipos de contribución

### Para estudiantes del curso
- **Reporte de error en código**: Si un archivo no compila o un test falla, abre un Issue usando la plantilla *Bug en código*.
- **Pregunta académica**: Dudas conceptuales van en la plantilla *Pregunta académica*.
- **Solución alternativa**: Si tienes una implementación más elegante, abre un Pull Request describiendo qué mejora aporta.

### Para docentes o colaboradores externos
- **Nueva práctica**: Propón prácticas adicionales con la plantilla *Propuesta de mejora*.
- **Corrección de contenido**: Errores conceptuales, referencias desactualizadas, o mejoras didácticas.

## Estándares de calidad para Pull Requests

Todo código enviado debe cumplir:

| Lenguaje | Requisito |
|----------|-----------|
| SWI-Prolog | Cargar sin errores: `swipl -g halt -l archivo.pl` |
| Erlang | Compilar: `erlc archivo.erl` |
| Haskell | Type-check: `ghc -fno-code archivo.hs` |
| Clojure | Ejecutar: `clj -M archivo.clj` |
| Elixir | Ejecutar: `elixir archivo.exs` |

Requisitos adicionales:
- Documentar aridad y determinismo en predicados Prolog (`%% pred/N — det|semidet|nondet`)
- Usar OTP behaviors en Erlang — nunca `spawn` sin supervisor
- Usar `Maybe`/`Either` en Haskell — nunca funciones parciales (`head`, `tail`) sin pattern matching exhaustivo
- Incluir al menos 3 tests plunit por módulo Prolog nuevo
- Contexto en ejemplos: preferir datos mexicanos ficticios (CURP, RFC, TecNM, IMSS)

## Proceso

1. Fork del repositorio
2. Crea una rama: `git checkout -b tema/descripcion-breve`
3. Realiza tus cambios siguiendo los estándares anteriores
4. Verifica que compila localmente
5. Abre un Pull Request con descripción clara del cambio

## Código de Conducta

Este proyecto sigue el [Código de Conducta](CODE_OF_CONDUCT.md).
Toda interacción debe ser respetuosa y constructiva.

## Contacto

**Dr. René Solís Reyes**
Departamento de Sistemas y Computación
TecNM Campus Tijuana
rene.solis@tectijuana.edu.mx
