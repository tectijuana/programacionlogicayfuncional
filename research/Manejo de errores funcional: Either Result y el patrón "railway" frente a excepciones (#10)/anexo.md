# Anexo — Bitácora de uso de LLM

**Tema:** Manejo de errores funcional: Either / Result y el patrón "railway" frente a excepciones
**Autor:** Rodríguez Peraza Carlos Eliab

## Herramienta utilizada

- Nombre: Claude (Anthropic)

## Prompts utilizados y resultados obtenidos

### Prompt 1
**Prompt real:**
> "Dame al menos diez fuentes confiables para realizar mi investigación sobre
> el tema 'Manejo de errores funcional: Either / Result y el patrón Railway
> frente a excepciones'."

**Resultado obtenido:**
La IA entregó una lista de 10 fuentes verificadas: el post original de Wlaschin,
un capítulo de libro en Springer Nature Link, la documentación oficial de
Hackage (`Data.Either` y el paquete `monad-rail`), la documentación oficial de
HexDocs (`with`), el blog de ingeniería de Discord sobre Elixir, el libro
*Programming Erlang* de Joe Armstrong, el tutorial oficial de la librería
Chessie (proyecto de la comunidad F#), la charla original de Wlaschin en video,
y su repositorio oficial en GitHub.

**¿Lo usé tal cual o lo modifiqué?**
Seleccioné de esta lista las fuentes que finalmente incluí en la bibliografía
de mi README, según lo que consideré más relevante para mi desarrollo técnico.

### Prompt 2
**Prompt real:**
> "Basándote en mi introducción y en mi tema, quiero que me ayudes a redactar
> el desarrollo técnico. Debe incluir ejemplos prácticos utilizando la
> estructura Either en Haskell o Elixir. Para ello, utiliza únicamente las
> fuentes confiables que te compartí."

**Resultado obtenido:**
La IA redactó una propuesta de desarrollo técnico apoyada solo en las fuentes
del Prompt 1: explicación del problema que resuelve Either/Result frente a
try/catch, ejemplos de código en Haskell (`Either`, notación `do`) y en Elixir
(`{:ok,_}`/`{:error,_}` con `with`), y una mención del uso de Elixir en Discord
respaldada en su blog de ingeniería.

**¿Lo usé tal cual o lo modifiqué?**
Tomé de esta propuesta lo que quise integrar a mi README y adapté/edité el
resto con mi propia redacción antes de la entrega final.

### Prompt 3
**Prompt real:**
> "Ya confirmé que el código funciona correctamente. Ahora realiza una tabla
> comparando excepciones vs. Either/Result, y detalla qué uso tienen en la
> industria."

**Resultado obtenido:**
La IA generó una tabla comparativa (visibilidad del error, verificación en
compilación, composición, rendimiento, rutas de error olvidadas) y un resumen
de uso en la industria respaldado en las fuentes ya verificadas: Discord y su
uso de Elixir en tiempo real, WhatsApp/Erlang documentado por Joe Armstrong, la
librería Chessie de la comunidad F# basada en el artículo original de Wlaschin,
y la librería `monad-rail` publicada en Hackage para Haskell.

**¿Lo usé tal cual o lo modifiqué?**
Integré la tabla y el resumen de industria en mi README, ajustando la
redacción a mi propio estilo antes de la entrega final.

## Reflexión crítica

- **¿La IA ayudó de verdad?** Sí me agilizó bastante el uso de IA para
  encontrar buenas fuentes para mi investigación. También me ayudó con los
  ejemplos, ya que yo no conocía mucho de esos lenguajes; me sirvió de
  introducción y logré entenderlos porque eran sencillos.
- **¿Hubo errores, imprecisiones o sesgos?** Solo me dio un error al momento de
  generar el código en Haskell, pero lo pude solucionar borrando la línea de
  código que causaba el conflicto.
- **¿Qué verifiqué por mi cuenta?** Verifiqué las fuentes y toda la información
  que me brindó. También comprobé el funcionamiento de los dos ejemplos de
  código.
- **¿Qué parte es mía y cuál partió de la IA?** Lo que me dio la IA fueron
  principalmente los ejemplos, ya que no conocía esos lenguajes de
  programación (aunque ya logré entenderlos un poco). Lo que considero 100%
  mío es la conclusión y la manera en la que organicé y redacté la
  información.

## Declaración

Confirmo que este anexo refleja el uso real que hice de herramientas de IA
durante esta investigación, y que la selección final de contenido y la
redacción del README.md son producto de mi propio criterio.
