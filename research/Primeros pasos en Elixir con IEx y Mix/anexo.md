# Bitácora de uso de IA

## Herramienta y propósito

- **Herramienta utilizada:** ChatGPT (OpenAI).
- **Propósito:** apoyar la organización inicial de la investigación y redactar ejemplos introductorios de IEx y Mix.
- **Fecha:** 2026-09-07.

## Prompts utilizados

1. «Realizar una pequeña investigación de: Primeros pasos en Elixir con IEx y Mix, y añadirla al repositorio en la carpeta `research`.»
2. «Explica la diferencia práctica entre IEx, `iex -S mix` y las tareas básicas de Mix para una persona que inicia en Elixir.»

## Resultado, revisión y validación

La asistencia propuso una estructura con resumen, introducción, desarrollo, conclusiones, ejemplos y bibliografía. Se revisó el contenido para separar claramente la consola IEx de la herramienta de proyecto Mix. Los comandos y el ejemplo `Saludo.para/1` se validaron localmente con la distribución instalada de Elixir, usando `mix format --check-formatted`, `mix test` y `mix run -e`.

Las afirmaciones sobre IEx y Mix se contrastaron con la documentación oficial de Elixir y HexDocs incluida en las referencias del `README.md`. La asistencia no sustituye esas fuentes: las versiones, opciones y salidas concretas deben verificarse con `mix help` y la documentación de la versión instalada.

## Reflexión crítica

La IA facilitó un primer borrador y ayudó a ordenar el flujo de trabajo, pero puede confundir comandos que cambian entre versiones o presentar ejemplos sin contexto. Por ello, el documento evita prometer una versión específica de Elixir, distingue las pruebas automatizadas de una comprobación manual en IEx y conserva referencias oficiales. La lección principal es que la REPL acelera la exploración, pero la validez de un programa debe confirmarse en un proyecto reproducible mediante compilación, formato y pruebas.

