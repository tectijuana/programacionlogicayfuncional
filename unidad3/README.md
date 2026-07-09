# Unidad 3 — Programación Lógica
## TecNM Tijuana — Ingeniería en Sistemas Computacionales

> "En Prolog describes QUÉ es verdad. El motor de inferencia decide CÓMO encontrarlo."

---

## Contenido de la unidad

| Tema | Descripción | Archivos |
|------|-------------|---------|
| [3.1](tema3.1/) | Hechos, consultas y base de conocimiento | `hechos_consultas.pl` |
| [3.2](tema3.2/) | Reglas, negación como falla, cut | `reglas_negacion.pl` |
| [3.3](tema3.3/) | Unificación y resolución | `unificacion.pl` |
| [3.4](tema3.4/) | Listas y aritmética desde cero | `listas.pl`, `aritmetica.pl` |
| [3.5](tema3.5/) | Proyecto: sistema experto médico | `diagnostico.pl`, `interfaz.pl` |

## Instalación de SWI-Prolog

```bash
# macOS
brew install swi-prolog

# Ubuntu/Debian
sudo apt install swi-prolog

# Verificar
swipl --version
```

## Evaluación

Esquema global del [sílabo](../SYLLABUS.md#evaluación): prácticas 40 % ·
proyecto integrador 40 % · exposición 20 %. En esta unidad el proyecto
integrador es el **sistema experto médico (tema 3.5)**; el contenido de la
unidad también se evalúa en el **Examen Parcial 2** (U3–U4, sem. 15).

## Modo de entrega

Todos los predicados deben:
1. Compilar sin errores ni warnings con `swipl -l archivo.pl`
2. Pasar los tests de plunit: `swipl -g "run_tests, halt" -l archivo.pl`
3. Incluir documentación de aridad y determinismo en cada predicado

## Regla de oro

> Código que no carga en SWI-Prolog = 0. Sin excepciones.
