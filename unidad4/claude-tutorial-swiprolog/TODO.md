---
tags: [todo, prolog, tutorial]
---

# TODO — Prolog Lab (tutorial interactivo SWI-Prolog)

## Arquitectura
- [x] `index.html`: xterm.js + swipl-wasm (modo Navegador)
- [x] Toplevel `?-` emulado (bindings, `;` / `.`, true/false)
- [x] Reproductor estilo asciinema (play/pausa/velocidad/reinicio)
- [x] Validador semántico (meta Prolog por reto)
- [x] Árbol de backtracking animado (metaintérprete, Prolog puro)
- [x] Progreso en `localStorage`
- [ ] Puente local `server.py` (WebSocket+pty, token, check `Origin`) — niveles 18+
- [ ] Dockerfile swipl ≥ 9.1.12 + Python (Janus)

## Deploy (fly.io)
- [x] `Dockerfile` (nginx estático) + `fly.toml` (región `lax`, 256 MB, auto-stop)
- [x] App `prolog-lab` en org personal (RENE SOLIS REYES): https://prolog-lab.fly.dev (2026-11-20)
- [x] Archivos responden 200 (`/`, `js/*.js`)
- [ ] Verificar en navegador que swipl-wasm carga desde el dominio de producción
- [ ] Dominio propio opcional: `fly certs add …` + CNAME
- [ ] Imagen aparte con swipl nativo + Python para niveles 18–20 (ver Arquitectura)
- Actualizar: `node tests/validar_lecciones.mjs && fly deploy`

## Pruebas
- [x] `node tests/validar_lecciones.mjs [id…]`: valida demos, retos, cruces y checks con swipl nativo (23/23)
- [x] Navegador (WASM): 69/69 retos resueltos con las soluciones de las pistas (2026-11-20)

## QA — 5 estudiantes simulados (2026-11-20)
- [x] Auto-consultar el programa al abrir lección (antes: retos daban `Unknown procedure` sin pulsar Demo)
- [x] Validador sin límite: `repeat, fail.` / `b :- b` congelaban la pestaña (lab_cols re-ejecutaba sin límite)
- [x] Validador re-imprimía `write/format`; no se valida si la consulta dio error
- [x] Falsos positivos (`padre(pedro,X)` = hijos de lucia; `N = 24.` tecleado): campo `usa` en retos
- [x] `;`/`.` sobrantes tras la última respuesta se pegaban a la siguiente consulta
- [x] Pistas en español para errores de sintaxis (mayúscula en predicado, espacio antes de `(`, falta coma)
- [x] Móvil: botones ≥ 40px
- [x] Doble clic en Consultar / Escribir en terminal tecleaba dos veces a la vez (texto revuelto)
- [x] Enter justo al terminar "Escribir en terminal" no validaba el reto (usaba `Player.driving`)
- [x] Validador: consultas sin variables (`run_tests.`) nunca aprobaban (`numlist(1,0,_)` falla)
- [ ] Móvil: `Restaurar` oculto (`#btnReset {display:none}`) → sin forma de recuperar el programa original
- [ ] `read/1` en WASM: verificar en navegador real (en headless bloquea la página: stdin → `prompt()`)
- [ ] `assertz` sobre predicado estático del programa da error de permiso: explicar `:- dynamic` en nivel 12

## Niveles 1–4
- [x] 1 Hechos y consultas — Familia (Bratko)
- [x] 2 Reglas y recursión — `ancestro/2`, viajes byCar/byTrain/byPlane (LPN)
- [x] 3 Unificación — crucigrama, líneas vertical/horizontal (LPN)
- [x] 4 Backtracking — coloreado de mapas (México), N reinas (4/8)

## Niveles
- [x] 5 Aritmética simbólica — Peano, Torres de Hanói
- [x] 6 Listas — último, append, comprimir, quicksort, mergesort
- [x] 7 Corte, negación, setof — problema de la cebra
- [x] 8 Búsqueda — granjero/lobo/cabra/col (profundidad iterativa)
- [x] 9 Búsqueda informada — 8-puzzle con A* (Manhattan)
- [x] 10 Planificación — mundo de bloques (STRIPS, anomalía de Sussman)
- [x] 11 Árboles y grafos — árboles binarios P-99, ruta más corta (Baja California)
- [x] 12 BD dinámica — ELIZA, assert/retract
- [x] 13 Sistemas expertos — identificación de animales con explicación `como/2`
- [x] 14 Metaprogramación — metaintérprete vanilla, profundidad, conteo
- [x] 15 DCG — aⁿbⁿ, evaluador de expresiones, `binario//0`
- [x] 16 CLP(FD) — SEND+MORE, Sudoku, horarios
- [x] 17 Módulos + plunit
- [x] 18 Webserver — lógica de rutas en navegador; servidor `http_server` en teoría (correr local)
- [x] 19 Janus — datos como hechos en navegador; `py_call`/`janus_swi` en teoría (correr local)
- [x] 20 Integrador — sistema experto de fallas + `api/2`; servidor/Python en local

### Pendientes de contenido
- [ ] 12 Mundo de Wumpus
- [ ] 8 Misioneros y caníbales, jarras, mono y plátano (solo mencionados en teoría)
- [ ] 7 powerset/permutaciones
- [ ] 13 Explicación `why` (solo `como/2`)
- [ ] 15 Intérprete de mini-lenguaje
- [ ] 16 N-reinas con CLP(FD)
- [ ] 18–20: probar en local el servidor HTTP y Janus de la teoría (no corren en WASM)
