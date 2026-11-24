<img width="1939" height="1027" alt="Screenshot 2026-11-23 at 11 19 47 p m" src="https://github.com/user-attachments/assets/8808bea4-2901-4b3e-a552-8f6ecd2fe9bd" />





# Tutorial SWI-Prolog



Tutorial de SWI-Prolog hecho con Claude Code. Carpeta usada como vault/nota de Obsidian.

## Estructura
- `index.html` — Prolog Lab: UI + estilos (xterm.js, swipl-wasm desde jsDelivr; SWI-Prolog 10.1 en runtime)
- `js/app.js` — terminal (toplevel emulado), reproductor de demos, editor, árbol SLD, retos
- `js/lab-core.js` — módulo Prolog `lab` (lab_solve, lab_check, lab_tree…) como string
- `js/lecciones.js` — contenido niveles 1–20: teoría, programa, `demo` (pasos), `retos` (query/program, `usa` opcional); `local: true` = nivel que requiere swipl local (http, janus no existen en WASM)
- `tests/validar_lecciones.mjs` + `tests/validar.pl` — valida todas las lecciones con swipl nativo
- `TODO.md` — tareas (checkboxes estilo Obsidian)

## Correr
- `python3 -m http.server 8765` → http://127.0.0.1:8765
- Al agregar lecciones: cada reto `query` debe tener un conjunto de respuestas distinto al de los
  otros retos (el validador compara columnas de soluciones); correr `node tests/validar_lecciones.mjs`.
- Variables `_X` en `ref` no cuentan como columnas; retos sin variables necesitan `usa`.

## Convenciones
- Prolog: SWI-Prolog 9+, un predicado por concepto, comentarios `%` en español.
- Ejecutar: `swipl -q -s archivo.pl`; tests con `plunit` (`swipl -g run_tests -t halt archivo.pl`).
- Markdown: compatible con Obsidian (`[[wikilinks]]`, `- [ ]` tareas, frontmatter YAML).
- Respuestas y comentarios en español.

## Reglas
- Actualizar `TODO.md` al terminar o añadir tareas.
- No agregar dependencias externas; solo librerías estándar de SWI-Prolog.
