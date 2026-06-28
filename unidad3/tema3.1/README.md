# Tema 3.1 — Hechos, Consultas y Base de Conocimiento

## Objetivo

Construir y consultar una base de conocimiento Prolog. Entender la diferencia entre hechos y consultas, y practicar el concepto de determinismo y no-determinismo en predicados.

## Instrucciones de ejecución

```bash
# Cargar el archivo e iniciar el REPL
swipl -l hechos_consultas.pl

# Ejecutar todos los tests y salir
swipl -g "run_tests, halt" -l hechos_consultas.pl

# Consulta de prueba rápida
swipl -g "imparte(P, prog_logica, _), write(P), nl, halt" -l hechos_consultas.pl
```

## Conceptos clave

| Concepto | Descripción | Ejemplo |
|----------|-------------|---------|
| **Hecho** | Afirmación incondicional | `departamento(sistemas).` |
| **Consulta** | Pregunta al motor de inferencia | `?- departamento(X).` |
| **Variable** | Empieza con mayúscula o `_` | `X`, `Prof`, `_Ignorado` |
| **Átomo** | Valor constante | `sistemas`, `solis_rene` |
| **det** | Produce exactamente una solución o falla | `profesor(solis_rene, N, D)` |
| **nondet** | Puede producir múltiples soluciones | `imparte(solis_rene, M, G)` |

## Actividad principal

Estudia el archivo `hechos_consultas.pl` y ejecuta en el REPL cada una de las 15 consultas de ejemplo. Para cada una:
1. Observa si produce una o varias soluciones (usa `;` para pedir la siguiente)
2. Identifica si el predicado es determinista o no-determinista
3. Entiende por qué Prolog devuelve las soluciones en ese orden

## Actividad de extensión

Agrega a la base de conocimiento:
1. Un 5° departamento: `mecatronica` con 2 profesores nuevos
2. 2 materias nuevas del plan ISC: `electrónica_digital` y `control`
3. Asignaciones de esas materias a los nuevos profesores
4. Un predicado `departamentos_con_mas_de_un_profesor/1` que use `findall` y `length`

Verifica que los tests existentes siguen pasando después de tus cambios.

## Preguntas de reflexión

1. ¿Por qué `mismo_departamento(solis_rene, solis_rene)` falla? ¿Cómo lo garantiza el código?
2. ¿Qué diferencia hay entre `imparte(P, prog_logica, _)` y `imparte(P, prog_logica, G)`?
3. Si escribes `?- departamento(X), write(X), nl, fail.`, ¿qué hace `fail` en ese contexto?
4. ¿Por qué `colegas/2` usa `P1 @< P2`? ¿Qué pasaría sin esa restricción?
5. ¿Cuántas soluciones tiene `?- mismo_departamento(X, Y).`? ¿Cómo lo calcularías?
6. ¿Es `carga_academica/2` determinista? ¿Depende de si `Profesor` está instanciado?
7. ¿Qué pasa si consultas `?- profesor(no_existe, N, D).`? ¿Error o fallo?
8. Explica la diferencia semántica entre `\+` y la negación lógica clásica.
9. ¿Por qué Prolog busca soluciones de arriba hacia abajo en el archivo?
10. Si agregas un hecho duplicado `departamento(sistemas).` dos veces, ¿qué ocurre?
